_APPLICATION_SCRIPT_PATH="/apps/jboss/jboss-eap-6.4.0/jboss-eap-6.4/bin"
_APPLICATION_SCRIPT="node2_ssui_Server.sh"
_NODE_FOLDER="/apps/jboss/script_promote/ssui_node2"


fcopy ()
    {
    ./usinginputFilePromote.sh >> $_NODE_FOLDER/promotelog_test.log
    if [ "$?" != 0 ] ; then
        echo "Promote failed for $_APPLICATION_SCRIPT called at $(date +"%x %r %Z")" >> $_NODE_FOLDER/promotelog_test.log
        exit 1
    fi
    }

frevert ()
    {
    ./usinginputFilePromote.sh >> $_NODE_FOLDER/promotelog_test.log
    if [ "$?" != 0 ] ; then
        echo "Promote failed for $_APPLICATION_SCRIPT called at $(date +"%x %r %Z")" >> $_NODE_FOLDER/promotelog_test.log
        exit 1
    fi
    }


# ------------------------------------
# Step #1: check JBOSS Server status
# ------------------------------------


echo "Server status Script for $_APPLICATION_SCRIPT called at $(date +"%x %r %Z")" >> $_NODE_FOLDER/promotelog_test.log
cd $_APPLICATION_SCRIPT_PATH;
./$_APPLICATION_SCRIPT status  >> $_NODE_FOLDER/promotelog_test.log
#sleep 30;


# ---------------------------------------------
# Step # 2: Copy Files for test folder simulate
# ---------------------------------------------

echo "Promote Script for $_APPLICATION_SCRIPT called at $(date +"%x %r %Z")" >> $_NODE_FOLDER/promotelog_test.log
cd $_NODE_FOLDER;
#./usinginputFilePromote.sh >> $_NODE_FOLDER/promotelog_test.log || ( echo "Promote failed for $_APPLICATION_SCRIPT called at $(date +"%x %r %Z")" >> $_NODE_FOLDER/promotelog_test.log;exit 1;)
#./usingrevertFilePromote.sh >> $_NODE_FOLDER/promotelog_test.log || ( echo "Promote failed for $_APPLICATION_SCRIPT called at $(date +"%x %r %Z")" >> $_NODE_FOLDER/promotelog_test.log;exit 1;)
#sleep 30;
fcopy
#frevert 


#echo ============================ test Completed Successfully =========================$'\n' >> $_NODE_FOLDER/promotelog_test.log
echo ============================ test Completed Successfully =========================$'\n'