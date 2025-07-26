# Directory navigation
alias cdo="cd ~-" # Go to last directory
alias cr="cd ~" 
alias pud="pushd"
alias pod="popd"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Terminal Display
alias l="ls -F"
alias ll="ls -lF"
alias la="ls -aF"
alias lla="ls -laF"
alias lal="ls -laF"
alias cl="clear" 
alias jb="cat ~/.jb_name_ascii_art"
alias h="history"

# File analysis
alias diff="diff --color=auto"
alias grep="grep -n --color=auto"
alias grepr="grep -n -R --color=auto"

# File creation and deletion
alias vi="vim"
alias vs="code"
alias vs="code"
alias t="touch"
alias rmr="rm -r"
alias rmf="rm -f"

# Makefile
alias m="make"
alias mm="make"

# Permissions
alias please="sudo"

# which command alternative
alias type="type -P"
alias typea="type -a" 

# Network configuration
myip='curl -s ipinfo.io/ip'

# Docker
function dc-fn {
        docker compose $*
}

function dcr-fn {
	docker compose run $@
}

function dex-fn {
	docker exec -it $1 ${2:-bash}
}

function di-fn {
	docker inspect $1
}

function dipls-fn {
    echo "IP addresses of all named running containers"

    for DOC in `dnames-fn`
    do
        IP=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$DOC"`
        OUT+=$DOC'\t'$IP'\n'
    done
    echo -e $OUT | column -t
    unset OUT
}

function dl-fn {
	docker logs -f $1
}

function dls-fn {
	for ID in `docker ps | awk '{print $1}' | grep -v 'CONTAINER'`
	do
    	docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}

function drmc-fn {
       docker rm $(docker ps --all -q -f status=exited)
}

function drmid-fn {
       imgs=$(docker images -q -f dangling=true)
       [ ! -z "$imgs" ] && docker rmi "$imgs" || echo "no dangling images."
}

function drun-fn {
	docker run -it $1 $2
}

function dsr-fn {
	docker stop $1;docker rm $1
}

alias dc=dc-fn
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcr=dcr-fn
alias dex=dex-fn  			#     dex <container>: execute a bash shell inside a running <container>
alias di=di-fn                     	#     di <container> : docker inspect <container>
alias dim="docker images" 		
alias dipls=dipls-fn                    #     dipls          : list IP addresses of all running containers
alias dl=dl-fn				#     dl <container> : docker logs -f <container>
alias dls=dls-fn 			#     dls            : list all running containers
alias dps="docker ps"
alias dpsa="docker ps -a"
alias drmc=drmc-fn			#     drmc           : remove all exited containers
alias drmid=drmid-fn 			#     drmid          : remove all dangling images
alias drun=drun-fn 			#     drun <image>   : execute a bash shell in a new container from <image>  
alias dsp="docker system prune --all"
alias dsr=dsr-fn  			#     dsr <container>: stop then remove <container>                        
