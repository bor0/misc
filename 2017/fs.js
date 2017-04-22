var fs = function() {
	var root = {
		name: '/',
		dirs: {},
		files: {},
	};

	root.parent = root;
	var curdir = root;

	this.mkdir = function (dirname) {
		if (!curdir.dirs[dirname]) {
			curdir.dirs[dirname] = {
				name: dirname,
				dirs: {},
				files: {},
				parent: curdir,
			};
		} else {
			throw new Error('Directory already exists');
		}
	};

	this.chdir = function (dirname) {
		if (dirname == '..') {
			curdir = curdir.parent;
		} else if (curdir.dirs[dirname]) {
			curdir = curdir.dirs[dirname];
		} else {
			throw new Error('Directory not found');
		}
	};

	this.rm = function(filename) {
		if (curdir.files[filename]) {
			delete curdir.files[filename];
		}
	};

	this.rmdir = function(dirname, tmp) {
		tmp = tmp || curdir;

		if (tmp.dirs[dirname]) {
			var dirkeys = Object.keys(tmp.dirs[dirname].dirs);
			// recurse on subdirs
			dirkeys.forEach(key => this.rmdir(tmp.dirs[dirname].dirs[key]));
			delete tmp.dirs[dirname];
		}
	};

	this.touch = function(filename, contents) {
		contents = contents || '';

		if (!curdir.files[filename]) {
			curdir.files[filename] = {
				name: filename,
				contents: contents,
			};
		} else {
			throw new Error('File already exists');
		}
	};

	this.ls = function() {
		var list = [];
		Object.keys(curdir.dirs).forEach(dir => list.push(dir + '/'));
		Object.keys(curdir.files).forEach(file => list.push(file));
		return list;
	};

	this.pwd = function() {
		return curdir.name;
	};

	this.cat = function(filename) {
		if (curdir.files[filename]) {
			return curdir.files[filename].contents;
		} else {
			throw new Error('File does not exist');
		}
	}

};

var myFs = new fs();

// REPL stuff
const readline = require('readline');

const rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout
});

function repl(myFs) {
	rl.question('> ', input => {
		input = input.split(' ').filter( x => x != '');

		try {
			switch (input[0]) {
				case 'exit':
				case 'quit':
					run = false;
					rl.close();
					return;
					break;
				case 'cat':
					console.log(myFs.cat(input[1]));
					break;
				case 'pwd':
					console.log(myFs.pwd());
					break;
				case 'ls':
					console.log(myFs.ls());
					break;
				case 'touch':
					myFs.touch(input[1], input[2]);
					break;
				case 'rmdir':
					myFs.rmdir(input[1]);
					break;
				case 'rm':
					myFs.rm(input[1]);
					break;
				case 'cd':
					myFs.chdir(input[1]);
					break;
				case 'mkdir':
					myFs.mkdir(input[1]);
					break;
				default:
					console.log('Unknown command.');
					break;
			}
		} catch (e) {
			console.log(e);
		}

		repl(myFs);
	});
}

repl(myFs);
