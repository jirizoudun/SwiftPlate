cartfile="Cartfile"
# if cartfile exits try to copy frameworks - otherwise do not proceed futher
if [ -f "$cartfile" ]
then
    COUNTER=0

    # each used framework should be defined by name in 'Input Names' of XCode BuildPhase
    while [ $COUNTER -lt ${SCRIPT_INPUT_FILE_COUNT} ] 
    do
        tmp="SCRIPT_INPUT_FILE_$COUNTER"
        FILE=${!tmp}

        FILENAME=$(basename $FILE)
        FILENAME=${FILENAME%.*}

    	for path in $FRAMEWORK_SEARCH_PATHS
    	do
    	    if [ -d "${path}/$FILENAME.framework" ] && [[ $path == *"Carthage"* ]]; then
    	        export SCRIPT_INPUT_FILE_COUNT=1
    	        export SCRIPT_INPUT_FILE_0="${path}/$FILENAME.framework"
    	        /usr/local/bin/carthage copy-frameworks
    	        break
    	    else
    	    	echo "warning: Framework $FILENAME not found. Did you run 'carthage bootstrap --configuration Debug' in project folder?"
    	    fi
    	done

        let COUNTER=COUNTER+1
	done
fi
