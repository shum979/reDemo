#!/bin/sh

echo "Starting with Flow xml file:" "$FILE"
if [[ -z "$1" ]]; then
    echo "Please specify the path to XML file as the first argument."
    exit;
fi
if [[ -z "$2" ]]; then
    echo "Please specify the path of location of package distribution as second argument."
    exit;
fi
if [[ -z "$3" ]]; then
    echo "WARN: No location of files have been specified which would be sent to executors. If some files need to be uploaded, for example schema files, specify it as the third parameter."
fi
EXTERNAL_JAR_LOCATION=$(grep "externalJarLocation" $2/config/app.conf | cut --delimiter="=" -f2- | tr -d '"')
echo "EXTERNAL_JAR_LOCATION: "$EXTERNAL_JAR_LOCATION
MASTER_URL=$(grep "master.url" $2/config/app.conf | cut --delimiter="=" -f2- | tr -d '"')
echo "MASTER_URL: "$MASTER_URL
DEPLOY_MODE=$(grep "deployMode" $2/config/app.conf | cut --delimiter="=" -f2- | tr -d '"')
echo "DEPLOY_MODE: "$DEPLOY_MODE
EXECUTOR_INSTANCES=$(grep "executor.instances" $2/config/app.conf | cut --delimiter="=" -f2- | tr -d '"')
echo "EXECUTOR_INSTANCES: "$EXECUTOR_INSTANCES
EXECUTOR_MEMORY=$(grep "executor.memory" $2/config/app.conf | cut --delimiter="=" -f2- | tr -d '"')
echo "EXECUTOR_MEMORY: "$EXECUTOR_MEMORY
EXECUTOR_CORES=$(grep "executor.cores" $2/config/app.conf | cut --delimiter="=" -f2- | tr -d '"')
echo "EXECUTOR_CORES: "$EXECUTOR_CORES
DRIVER_MEMORY=$(grep "driver.memory" $2/config/app.conf | cut --delimiter="=" -f2- | tr -d '"')
echo "DRIVER_MEMORY: "$DRIVER_MEMORY
JAR_NAME_LIST=""
for i in $(find $EXTERNAL_JAR_LOCATION -name *.jar)
do
if [ $JAR_NAME_LIST != "" ]; then
        DELIMITER=,
else
        DELIMITER=
fi
JAR_NAME_LIST=$JAR_NAME_LIST$DELIMITER$i
done
echo "External JARs List: " + $JAR_NAME_LIST
if [ $1 != "" ]; then
    if [ $JAR_NAME_LIST != "" ]; then
        if [ $DEPLOY_MODE != "" ]; then
            spark-submit --driver-class-path $2/config  --driver-memory $DRIVER_MEMORY --master $MASTER_URL --deploy-mode $DEPLOY_MODE --executor-memory $EXECUTOR_MEMORY --executor-cores $EXECUTOR_CORES --num-executors $EXECUTOR_INSTANCES --jars $JAR_NAME_LIST --files $2/config/app.conf,$2/config/log4j.properties,$1,$3 --conf spark.dynamic.allocation=false --conf spark.dynamicAllocation.enabled=false --class com.sapient.main.OpenBankApp $2/lib/open-bank-fluid-data.jar $1
        else
            spark-submit --driver-class-path $2/config --driver-memory $DRIVER_MEMORY --master $MASTER_URL --executor-memory $EXECUTOR_MEMORY --executor-cores $EXECUTOR_CORES --num-executors $EXECUTOR_INSTANCES --jars $JAR_NAME_LIST  --files $2/config/app.conf,$2/config/log4j.properties,$1,$3 --conf spark.dynamic.allocation=false --conf spark.dynamicAllocation.enabled=false --class com.sapient.main.OpenBankApp $2/lib/open-bank-fluid-data.jar $1
        fi
    else
        if [ $DEPLOY_MODE != "" ]; then
            spark-submit --driver-class-path $2/config --driver-memory $DRIVER_MEMORY --master $MASTER_URL --deploy-mode $DEPLOY_MODE --executor-memory $EXECUTOR_MEMORY --executor-cores $EXECUTOR_CORES --num-executors $EXECUTOR_INSTANCES --files $2/config/app.conf,$2/config/log4j.properties,$1,$3 --conf spark.dynamic.allocation=false --conf spark.dynamicAllocation.enabled=false --class com.sapient.main.OpenBankApp $2/lib/open-bank-fluid-data.jar $1
        else
            spark-submit --driver-class-path $2/config --driver-memory $DRIVER_MEMORY --master $MASTER_URL --executor-memory $EXECUTOR_MEMORY --executor-cores $EXECUTOR_CORES --num-executors $EXECUTOR_INSTANCES --files $2/config/app.conf,$2/config/log4j.properties,$1,$3 --conf spark.dynamic.allocation=false --conf spark.dynamicAllocation.enabled=false --class com.sapient.main.OpenBankApp $2/lib/open-bank-fluid-data.jar $1
        fi
    fi
else
    echo "Please provide DataSource XML file to start."
fi
