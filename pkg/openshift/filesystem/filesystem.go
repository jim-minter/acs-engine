package filesystem

import (
	"archive/tar"
	"io"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"
)

// Fileinfo is a struct that holds User, Group, and Mode
type Fileinfo struct {
	User  string
	Group string
	Mode  os.FileMode
}

// Filesystem provides methods which are runnable on a bare filesystem or a
// tar.gz file
type Filesystem interface {
	Mkdir(filename string, fileInfo Fileinfo) error
	WriteFile(filename string, data []byte, fileInfo Fileinfo) error
	Close() error
}

type filesystem struct {
	name string
}

var _ Filesystem = &filesystem{}

// NewFilesystem returns a Filesystem interface backed by a bare filesystem
func NewFilesystem(name string) (Filesystem, error) {
	err := os.RemoveAll(name)
	if err != nil {
		return nil, err
	}

	err = os.MkdirAll(name, 0777)
	if err != nil {
		return nil, err
	}

	return &filesystem{name}, nil
}

// Mkdir called directly and takes permissions/ownership
func (f *filesystem) Mkdir(name string, fileInfo Fileinfo) error {
	return os.Mkdir(name, fileInfo.Mode)
}

// mkdirAll this does not chown/chgrp as that would require elevated privileges
func (f *filesystem) mkdirAll(name string) error {
	return os.MkdirAll(name, 0755)
}

func (f *filesystem) WriteFile(filename string, data []byte, fileInfo Fileinfo) error {
	filePath := filepath.Join(f.name, filename)
	err := f.mkdirAll(filepath.Dir(filePath))
	if err != nil {
		return err
	}

	return ioutil.WriteFile(filePath, data, fileInfo.Mode)
}

func (filesystem) Close() error {
	return nil
}

type tarxzfile struct {
	cmd  *exec.Cmd
	wc   io.WriteCloser
	tw   *tar.Writer
	now  time.Time
	dirs map[string]struct{}
}

var _ Filesystem = &tarxzfile{}

// NewTarXZFile returns a Filesystem interface backed by a tar.bz2 file
func NewTarXZFile(w io.Writer) (Filesystem, error) {
	cmd := exec.Command("xz")
	wc, err := cmd.StdinPipe()
	if err != nil {
		return nil, err
	}
	cmd.Stdout = w
	err = cmd.Start()
	if err != nil {
		return nil, err
	}
	tf := &tarxzfile{
		cmd:  cmd,
		wc:   wc,
		tw:   tar.NewWriter(wc),
		now:  time.Now(),
		dirs: map[string]struct{}{},
	}
	return tf, nil
}

// Mkdir called directly and takes permissions/ownership
func (t *tarxzfile) Mkdir(name string, fileInfo Fileinfo) error {
	if _, exists := t.dirs[name]; exists {
		return &os.PathError{Op: "mkdir", Path: name}
	}

	err := t.tw.WriteHeader(&tar.Header{
		Name:     name,
		Mode:     int64(fileInfo.Mode),
		ModTime:  t.now,
		Typeflag: tar.TypeDir,
		Uname:    fileInfo.User,
		Gname:    fileInfo.Group,
	})
	if err != nil {
		return err
	}
	t.dirs[name] = struct{}{}

	return nil
}

// mkdirAll creates all directories in a string delimited by '/'
// this function does not chown/chgrp as that would require elevated privileges
func (t *tarxzfile) mkdirAll(name string) error {
	parts := strings.Split(name, "/")
	for i := 1; i < len(parts); i++ {
		name = filepath.Join(parts[:i]...)
		if _, exists := t.dirs[name]; exists {
			continue
		}

		err := t.Mkdir(name, Fileinfo{Mode: 0755, User: "root", Group: "root"})
		if err != nil {
			return err
		}
	}
	return nil
}

func (t *tarxzfile) WriteFile(filename string, data []byte, fileInfo Fileinfo) error {
	err := t.mkdirAll(filepath.Dir(filename))
	if err != nil {
		return err
	}

	err = t.tw.WriteHeader(&tar.Header{
		Name:     filename,
		Mode:     int64(fileInfo.Mode),
		Size:     int64(len(data)),
		ModTime:  t.now,
		Typeflag: tar.TypeReg,
		Uname:    fileInfo.User,
		Gname:    fileInfo.Group,
	})
	if err != nil {
		return err
	}

	_, err = t.tw.Write(data)
	return err
}

func (t *tarxzfile) Close() error {
	err := t.tw.Close()
	if err != nil {
		return err
	}
	err = t.wc.Close()
	if err != nil {
		return err
	}
	return t.cmd.Wait()
}
