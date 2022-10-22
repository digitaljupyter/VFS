# VFS

Implementation of a basic filesystem.

The filesystem uses one root directory called "root".

## How it works

When you create a new filesystem, there will be one root node, called root, which can be accessed with `.rootNode()`

After that, you will be in a directory which contains everything in the root node.

### Files

You can create a virtual file with the `VFile` class. Here's an example of creating a file with basic `READ_WRITE` permissions:

```dlang
VFile myFile = new VFile("sample_file.txt");
myFile.writeContent("Hello, world!");
myFile.setPermissions(VPerm.read_write);
```

Note: exceptions will be thrown if you try to read or write to a file which is not read/write.

### Directories

Directories aren't the actual implementation of a "folder" per-say; They actually have a parent node called a "`VContainer`". Containers have a `files` array and a `directories` array. VContainers are not recommended to operate on and you should use the `VDirectory` functions such as `.getFile()` and `.getDirectory()`

Here's an example of creating a basic directory with a file called "hello"

```dlang
VFileSys sys = new VFileSys();
VDirectory root = sys.rootNode();

VFile file = new VFile(file_name);
file.contents = file_text;
file.setPermissions(VPerm.read_write);

root.addFile(file);
```

### Containers

Containers contain files and directories. This functionality is wrapped by the `VDirectory` class.

They contain a `files` array containing a bunch of `VFile`s and a `directories` array containing a few `VDirectory`.
