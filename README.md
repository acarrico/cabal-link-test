Cabal doesn't seem to relink an executable to a library that it builds. This would seem to be
related to https://ghc.haskell.org/trac/ghc/ticket/10161, but it in this case there /is/ a new
timestamp. See the following transcript:

```
[nix-shell:~/cabal-link-test]$ cabal run hello
Resolving dependencies...
Configuring cabal-link-test-0...
Preprocessing library for cabal-link-test-0..
Building library for cabal-link-test-0..
Preprocessing executable 'hello' for cabal-link-test-0..
Building executable 'hello' for cabal-link-test-0..
[1 of 1] Compiling Main             ( Main.hs, dist/build/hello/hello-tmp/Main.o )
Linking dist/build/hello/hello ...
Running hello...
hello
```

```
[nix-shell:~/cabal-link-test]$ ls -l dist/build/lib* dist/build/hello/hello hello.c
-rwxr-xr-x 1 acarrico users 909952 Dec 11 13:05 dist/build/hello/hello
-rw-r--r-- 1 acarrico users   1814 Dec 11 13:05 dist/build/libHScabal-link-test-0-8xshPk1VcQfLy9KOPXdemN.a
-rwxr-xr-x 1 acarrico users   8992 Dec 11 13:05 dist/build/libHScabal-link-test-0-8xshPk1VcQfLy9KOPXdemN-ghc8.2.2.so
-rw-r--r-- 1 acarrico users     86 Dec 11 13:05 hello.c
```

Change hello to goodbye in hello.c.

```
[nix-shell:~/cabal-link-test]$ ls -l dist/build/lib* dist/build/hello/hello hello.c
-rwxr-xr-x 1 acarrico users 909952 Dec 11 13:05 dist/build/hello/hello
-rw-r--r-- 1 acarrico users   1814 Dec 11 13:05 dist/build/libHScabal-link-test-0-8xshPk1VcQfLy9KOPXdemN.a
-rwxr-xr-x 1 acarrico users   8992 Dec 11 13:05 dist/build/libHScabal-link-test-0-8xshPk1VcQfLy9KOPXdemN-ghc8.2.2.so
-rw-r--r-- 1 acarrico users     88 Dec 11 13:07 hello.c
```

```
[nix-shell:~/cabal-link-test]$ cabal run hello
Preprocessing library for cabal-link-test-0..
Building library for cabal-link-test-0..
Preprocessing executable 'hello' for cabal-link-test-0..
Building executable 'hello' for cabal-link-test-0..
Running hello...
hello
```

That should have printed goodbye.

```
[nix-shell:~/cabal-link-test]$ ls -l dist/build/lib* dist/build/hello/hello hello.c
-rwxr-xr-x 1 acarrico users 909952 Dec 11 13:05 dist/build/hello/hello
-rw-r--r-- 1 acarrico users   1814 Dec 11 13:07 dist/build/libHScabal-link-test-0-8xshPk1VcQfLy9KOPXdemN.a
-rwxr-xr-x 1 acarrico users   8992 Dec 11 13:07 dist/build/libHScabal-link-test-0-8xshPk1VcQfLy9KOPXdemN-ghc8.2.2.so
-rw-r--r-- 1 acarrico users     88 Dec 11 13:07 hello.c
```

Note that the hello executable is stale.

```
[nix-shell:~/cabal-link-test]$ touch Main.hs
```

```
[nix-shell:~/cabal-link-test]$ cabal run hello
Preprocessing library for cabal-link-test-0..
Building library for cabal-link-test-0..
Preprocessing executable 'hello' for cabal-link-test-0..
Building executable 'hello' for cabal-link-test-0..
[1 of 1] Compiling Main             ( Main.hs, dist/build/hello/hello-tmp/Main.o )
Linking dist/build/hello/hello ...
Running hello...
goodbye
```

```
[nix-shell:~/cabal-link-test]$ ls -l dist/build/lib* dist/build/hello/hello hello.c
-rwxr-xr-x 1 acarrico users 909952 Dec 11 13:12 dist/build/hello/hello
-rw-r--r-- 1 acarrico users   1814 Dec 11 13:07 dist/build/libHScabal-link-test-0-8xshPk1VcQfLy9KOPXdemN.a
-rwxr-xr-x 1 acarrico users   8992 Dec 11 13:12 dist/build/libHScabal-link-test-0-8xshPk1VcQfLy9KOPXdemN-ghc8.2.2.so
-rw-r--r-- 1 acarrico users     88 Dec 11 13:07 hello.c
```

Touching Main.hs links to the new library.
