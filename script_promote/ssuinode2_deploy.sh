_APPLICATION_SCRIPT_PATH="/apps/jboss/jboss-eap-6.4.0/jboss-eap-6.4/bin"
_APPLICATION_SCRIPT="ssui_node2_Server.sh"
_NODE_FOLDER="/apps/jboss/script_promote/ssui_node2"


fcopy ()
    {
	cd $_NODE_FOLDER;
    	./usinginputFilePromote.sh >> $_NODE_FOLDER/promotelog.log
    	if [ "$?" != 0 ] ; then
        	echo "Promote failed for $_APPLICATION_SCRIPT called at $(date +"%x %r %Z")" >> $_NODE_FOLDER/promotelog.log
        	exit 1
    	fi
    }


echo "Deploy Script for $_APPLICATION_SCRIPT called at $(date +"%x %r %Z")" >> $_NODE_FOLDER/promotelog.log


# ----------------------------------
# Step #1: stop JBOSS Server
# ---------------------------------


echo "Server Stop Script for $_APPLICATION_SCRIPT called at $(date +"%x %r %Z")" >> $_NODE_FOLDER/promotelog.log
cd $_APPLICATION_SCRIPT_PATH
./$_APPLICATION_SCRIPT stop >> $_NODE_FOLDER/promotelog.log
sleep 30;


# ----------------------------------
# Step #2: Copy Files for promote
# ---------------------------------

echo "Promote Script for $_APPLICATION_SCRIPT called at $(date +"%x %r %Z")" >> $_NODE_FOLDER/promotelog.log
fcopy
sleep 30;

# ---------------------------------------
# Step #3: Start the server post promote
# ---------------------------------------

echo "Server Start Script for $_APPLICATION_SCRIPT called at $(date +"%x %r %Z")" >> $_NODE_FOLDER/promotelog.log
cd $_APPLICATION_SCRIPT_PATH;
./$_APPLICATION_SCRIPT deploy >> $_NODE_FOLDER/promotelog.log
sleep 120;

echo ============================ Deploy Completed Successfully =========================$'\n' >> $_NODE_FOLDER/promotelog.log
