# !/bin/bash
function removeFolder {
    rm -R .metadata/gpubSub && echo 'Folder .metadata/gpubSub removed'
}

function convertMetadata {
    echo 'Converting Source'
    sfdx force:source:convert -r force-app/ -d .metadata/gpubSub -n 'gpubSub'
}

function deployMetadata {
    echo 'Deploying Converted Source to org'
    sfdx force:mdapi:deploy -d .metadata/gpubSub -w -1
}

removeFolder && convertMetadata && deployMetadata