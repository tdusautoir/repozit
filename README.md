# repozit

A linux bash to create a repository on github and locally in order to link them. 

## How to use repozit.sh :

Be careful, you must have git and curl installed.

Usage: 

```sh
./repozit.sh (-o|--opt)
```

Options :

-n, --name: insert the name of repo.  
-d, --description: Insert the description for the repo.  
-p, --path: insert your project path from the actual directory.  
-u, --username: insert your github username.  
-t, --token: insert your github token.
-a, --all: insert all of the arguments, use is as -a [name] [description] [path] [username] [token]
-v, --version: Prints version.  
-h, --help: Prints help.  

Exemple 

```sh
./repozit.sh -a nameRepo "my repo description" ./ tdusautoir myToken
```
