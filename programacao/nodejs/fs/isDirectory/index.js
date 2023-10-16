// Node.js program to demonstrate the
// dirent.isDirectory() method
const fs = require("fs");

// Initiating async function
async function stop(path) {
  // Creating and initiating directory's
  // underlying resource handle
  const dir = await fs.promises.opendir(path);

  // Synchronously reading the directory's
  // underlying resource handle using
  // readSync() method
  for (let i = 0; i <= 3; i++) {
    // Checking if the particular dirent
    // is Directory or not by using
    // isDirectory() method
    const n=dir.path;
    const value = dir.readSync().isDirectory();

    // Display the result
    console.log(dir.readSync());
    console.log(value);
    console.log(n);
  }
}

// Catching error
stop("./").catch(console.error);
