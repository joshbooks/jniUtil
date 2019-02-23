# jniUtil
The JNI is super useful, but sometimes it's kind of a pain to work with.
Every time I work with it I find myself doing the same painful things I did the last time I 
worked with it.

For a long while I just lived with the Sisyphean absurdity, but it's time for that to stop.

So far this is just four bash scripts but with just those I feel less dread at the prospect 
of working with the JNI.

These scripts assume your classes live in `./target/classes`, so if you're not using maven 
you'll need to do a bit of wrangling (or submit a PR to generalize :D ).

## Requirements

GNU Bash 4.0 or greater (for associative arrays and gnu `find` options)

A project with class files that live in `target/classes` (If you're using Maven you're probably fine)

## Usage
Since these are bash scripts you can just clone and run:
```bash
cd /some/directory/
git clone https://github.com/joshbooks/jniUtil.git
```
The first script generates the JNI header files for your classes in a sister `jni` directory.
So `cd` to your project directory (parent of `target`).
Assuming you're using maven and have run `mvn package` or another lifecycle command that
generates class files you would just run:
```bash
/some/directory/jniUtil/mkJni.sh
```
if you `ls -R ./jni`you should see a file structure that mirrors your class structure
filled up with JNI headers. So go ahead and write some `.c` files.

Once you've done that you'll probably want to get rid of some of the JNI  header files.
Specifically the ones that aren't included in any `.c` files(or `.h` files included by 
`.c` files).
To do that just `cd` back up to the project directory (parent of `target` and `jni`) and
run 
```bash
/some/directory/jniUtil/pruneJni.sh
```

You'll notice I specifically reference `.c` files. `pruneJni.sh` does not recognize `.rs`,
`.cpp`, `.objc` or any other type of source file currently.


You can make a shared library with jniMake.sh. To do that just run
```bash
/some/directory/jniUtil/jniMake.sh
```
and it will emit a shared library named `jniUtilLib.solib` containing all your
JNI code in `./`


## Plans for expansion
I'm currently working on a project ([JoshDB](https://www.github.com/joshbooks/JoshDB) to be specific)
that uses the JNI, so as I do things with the JNI I'm going to try to write scripts that 
automate those tasks so I never have to do them again. I think the next thing 
I'm going to run into is building a JNI library from maven automagically 
in the maven lifecycle and including jniUtilLib.solib in a `.jar` file
automagically. Be nice if I could insert code directly into pom.xml, but
producing the snippets that need to be inserted would a very good first step
