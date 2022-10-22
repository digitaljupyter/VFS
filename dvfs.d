module dvfs;

/* D Virtual File System */

// Each filesystem is made of different classes, each filesystem
// Starts with a root VDirectory. That directory contains it's own directories and
// so on, so forth.

enum VPerm {
    read,
    write,
    read_write,
    hardened, // ex: file that should not be modified
    error
}

class FileSystemException : Exception {
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null) pure nothrow @nogc @safe {
        super(msg, file, line, nextInChain);
    }
}

class PermissionException : FileSystemException {
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null) pure nothrow @nogc @safe {
        super(msg, file, line, nextInChain);
    }
}

class FileNotFoundException : FileSystemException {
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null) pure nothrow @nogc @safe {
        super(msg, file, line, nextInChain);
    }
}

class VFile {
    private string name = "";
    private VPerm file_permission = VPerm.read;
    public string contents = "";

    public void setPermissions(VPerm perm) {
        this.file_permission = perm;
    }

    this(string _name) {
        this.name = _name;
    }

    string readFileText() {
        if (file_permission == (VPerm.read | VPerm.read_write))
            return this.contents;
        else
            throw new PermissionException("readFileText(): Permission denied");
    }

    public string getFileName() {
        
        return this.name;
    }

    public void writeContent(string text) {
        if (file_permission == (VPerm.write | VPerm.read_write))
            contents ~= text;
        else
            throw new PermissionException("writeFileText(): Permission denied to write");
    }
}

class VDirectory {
private:
    VContainer containerNode = new VContainer; /* contains files and directories */
    string name;
    VPerm permission = VPerm.read; /* read-only defaults */
public:
    this() {
    }

    this(string _name) {
        this.name = _name;
    }

    VPerm getDirectoryPermissions() {
        return this.permission;
    }

    string getDirectoryName() {
        return this.name;
    }

    VFile[] getFiles() {
        return this.containerNode.files;
    }

    VFile getFile(string byThisName) {
        return this.containerNode.getFileByName(byThisName);
    }

    void addFile(VFile file) {
        this.containerNode.files ~= file;
    }

    VDirectory getDirectory(string byThisName) {
        return this.containerNode.getDirectoryByName(byThisName);
    }

    void createDirectory(VDirectory dirW) {
        this.containerNode.directories ~= dirW;
    }

    void setDirectoryPermissions(VPerm p) {
        this.permission = p;
    }

    void setDirectoryName(string text) {
        this.name = text;
    }
}

class VContainer {
    public VFile[] files = [];
    public VDirectory[] directories = [];

    public VDirectory getDirectoryByName(string n) {
        foreach (VDirectory dir; directories) {
            if (dir.getDirectoryName() == n)
                return dir;
        }
        auto nilDir = new VDirectory();
        nilDir.setDirectoryPermissions(VPerm.error);
        return nilDir;
    }

    public VFile getFileByName(string name) {
        foreach (VFile f; files) {
            if (f.getFileName() == name)
                return f;
        }
        throw new FileNotFoundException("The file, '" ~ name ~ "' was not found.");
    }
}

class VFileSys {
    private VDirectory root = new VDirectory("root");

    public VDirectory rootNode() {
        return this.root;
    }
}
