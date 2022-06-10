#!/bin/bash
version="0.1"

#  ______     ______     ______   ______     ______     __     ______  
# /\  == \   /\  ___\   /\  == \ /\  __ \   /\___  \   /\ \   /\__  _\ 
# \ \  __<   \ \  __\   \ \  _-/ \ \ \/\ \  \/_/  /__  \ \ \  \/_/\ \/ 
#  \ \_\ \_\  \ \_____\  \ \_\    \ \_____\   /\_____\  \ \_\    \ \_\ 
#   \/_/ /_/   \/_____/   \/_/     \/_____/   \/_____/   \/_/     \/_/ 

die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}

print_help()
{
    echo -e " \033[33m
\033[31m  ______   \033[32m  ______   \033[33m  ______  \033[34m  ______  \033[35m   ______   \033[36m  __   \033[37m  ______  
\033[31m /\  == \  \033[32m /\  ___\  \033[33m /\  == \ \033[34m /\  __ \ \033[35m  /\___  \  \033[36m /\ \  \033[37m /\__  _\ 
\033[31m \ \  __<  \033[32m \ \  __\  \033[33m \ \  _-/ \033[34m \ \ \/\ \ \033[35m \/_/  /__  \033[36m\ \ \  \033[37m\/_/\ \/ 
\033[31m  \ \_\ \_\ \033[32m \ \_____\ \033[33m \ \_\  \033[34m   \ \_____\  \033[35m /\_____\ \033[36m \ \_\  \033[37m  \ \_\ 
\033[31m   \/_/ /_/ \033[32m  \/_____/ \033[33m  \/_/  \033[34m    \/_____/ \033[35m  \/_____/  \033[36m \/_/  \033[37m   \/_/  \033[0m
                                                                     
"
    printf '%s\n' "Be careful, you must have git and curl installed."
	printf '%s\n' "How to use repozit.sh"
	printf 'Usage: %s [-a|--all] [-n|--name] [-p|--path] [-u|--username] [-t|--token] [-v|--version] [-h|--help]\n' "$0"
    printf '\t%s\n' "-n, --name: insert the name of repo"
    printf '\t%s\n' "-d, --description: Insert the description for the repo"
    printf '\t%s\n' "-p, --path: insert your project path from the actual directory"
    printf '\t%s\n' "-u, --username: insert your github username"
    printf '\t%s\n' "-t, --token: insert your github token"
    printf '\t%s\n' "-a, --all: insert all of your argument, use it as -a [name] [description] [path] [username] [token]"
	printf '\t%s\n' "-v, --version: Prints version"
	printf '\t%s\n' "-h, --help: Prints help"
}

#INIT VARIABLE
name=""
description=""
path=""
username=""
token=""

InitRepo(){
    if [ "$name" = "" ] && [ "$description" = "" ] && [ "$path" = "" ] && [ "$username" = "" ] && [ "$token" = "" ]
    then 
        echo -e " \033[33m
\033[31m  ______   \033[32m  ______   \033[33m  ______  \033[34m  ______  \033[35m   ______   \033[36m  __   \033[37m  ______  
\033[31m /\  == \  \033[32m /\  ___\  \033[33m /\  == \ \033[34m /\  __ \ \033[35m  /\___  \  \033[36m /\ \  \033[37m /\__  _\ 
\033[31m \ \  __<  \033[32m \ \  __\  \033[33m \ \  _-/ \033[34m \ \ \/\ \ \033[35m \/_/  /__  \033[36m\ \ \  \033[37m\/_/\ \/ 
\033[31m  \ \_\ \_\ \033[32m \ \_____\ \033[33m \ \_\  \033[34m   \ \_____\  \033[35m /\_____\ \033[36m \ \_\  \033[37m  \ \_\ 
\033[31m   \/_/ /_/ \033[32m  \/_____/ \033[33m  \/_/  \033[34m    \/_____/ \033[35m  \/_____/  \033[36m \/_/  \033[37m   \/_/  \033[0m
                                                                    
"
        echo "-h or --help to use it with argument"
        echo ""
        echo "Initialise your repo git in github and locally"
        echo "----------------------------------------------"
        echo ""
    fi
    case $name in
        "")
        echo "What's the name of your repo ?"
        read name
    esac
    case $description in
        "")
        echo "Enter the description for the repo"
        read description
        ;;
    esac
    case $path in
        "")
        echo "Enter your project path (from your actual directory)"
        read path
        ;;
    esac
    case $username in
        "")
        echo "Enter your github username"
        read username
        ;;
    esac
    case $token in
        "")
        echo "Enter your github token"
        read token
        ;;
    esac

    # etape 1 : Creer le dossier localement et y acceder
    mkdir $path$name
    cd $path$name

    # etape 2 : Initialiser votre repo localement, ajouter un readme, init git et commit
    echo "# $name" >> README.md
    git init
    git add README.md
    git commit -m "first commit"

    # etape 3 : Utilisation de l'api github pour se connecter et créer le repo
    curl -u ${username}:${token} https://api.github.com/user/repos -d "{\"name\": \"${name}\", \"description\": \"${description}\"}"

    # etape 4 :  Connecter le repo local au repo distant github et push le contenu
    git remote remove origin
    git remote add origin https://github.com/$username/$name.git
    git push --set-upstream origin master

    projectpath=$(pwd)

    echo "Voulez vous ouvrir votre repo via votre navigateur (y\n) ? "
    read choice
    if [ "$choice" == "y" ]
    then
    open https://github.com/$username/$name
    else
    echo "Aller sur https://github.com/$username/$name pour acceder a votre repo distant."
    fi
    echo "Votre repo initialisé : $projectpath"
}

parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
            -n|--name)
				test $# -lt 2 && die "Missing name for the repo '$_key'." 1
                name=$2
                InitRepo
                exit 0
				;;
            -d|--description)
				test $# -lt 2 && die "Missing description for the repo '$_key'." 1
                description=$2
                InitRepo
                exit 0
				;;
            -p|--path)
                test $# -lt 2 && die "Missing path for the diretory '$_key'." 1
                description=$2
                InitRepo
                exit 0
            ;;  
            -u|--username)
                test $# -lt 2 && die "Missing username for github api '$_key'." 1
                username=$2
                InitRepo
                exit 0
                ;;
            -t|--token)
                test $# -lt 2 && die "Missing token for github api '$_key'." 1
                description=$2
                InitRepo
                exit 0
            ;;   
			-v|--version)
				echo "Repozit" v$version
				exit 0
				;;
			-v*)
				echo "Repozit v$version"
				exit 0
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
            -a|--all)
                if (( $# == 6))
                then
                    name=$2
                    description=$3
                    path=$4
                    username=$5
                    token=$6
                    InitRepo
                else
                    echo "You insert too much argument or less than expected."
                    echo "Use it as : ./repozit.sh -a [name] [description] [path] [username] [token]"
                    exit;
                fi
                exit 0
                ;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"
# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

InitRepo

# ] <-- needed because of Argbash