##
# Exports
##

##
# Functions
##
function process_profile() {
    local directory
    directory=$1
    for file_name in $(ls $directory) ; do
        local file_path
        file_path="${directory}/${file_name}"
        if [ -d "${file_path}" ] ; then
            process_profile "${file_path}"
        else
            source ${file_path}
        fi
    done
}

function project() {
    if [ "${1}" = "" ] ; then
        echo "Please, specifiy a project via 'project <name>'"
        return
    fi
    if ! [ -d ~/Projects/${1} ] ; then
        echo "Project '$1' does not exist!"
        return
    fi
    cd ~/Projects/${1}
}

##
# Aliases
##
alias l='ls -lah'
alias projects="cd ~/Projects"

##
# Main
##
if [ -d "${HOME}/.profile.d" ] ; then
    process_profile ${HOME}/.profile.d
fi