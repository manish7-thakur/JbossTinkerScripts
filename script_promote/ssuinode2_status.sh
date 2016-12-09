_APPLICATION_SCRIPT_PATH="/apps/jboss/jboss-eap-6.4.0/jboss-eap-6.4/bin"
_APPLICATION_SCRIPT="ssui_node2_Server.sh"
_NODE_FOLDER="/apps/jboss/script_promote/ssui_node2"

cd $_APPLICATION_SCRIPT_PATH;
pwd;
./$_APPLICATION_SCRIPT status >> $_NODE_FOLDER/promotelog_test.log
SERVER_STATUS=`./$_APPLICATION_SCRIPT status | grep instance | grep -o -P '(?<=-).*'`;
if [[ $SERVER_STATUS =~ .*pid.* ]]
	then
 		SERVER_STATUS="[$SERVER_STATUS]";
		echo "Success";
		exit 0;
	else
		SERVER_STATUS="[$SERVER_STATUS]";
		echo "Failure";
		exit 1;
	fi
