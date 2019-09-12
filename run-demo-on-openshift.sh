cd /tmp
mkdir recon
cd recon

wget https://raw.githubusercontent.com/shum979/reDemo/master/RECON_DEMO.tar

tar -xvf RECON_DEMO.tar

rm RECON_DEMO.tar
cd RECON_DEMO

export APP_DIR=/tmp/recon/RECON_DEMO/open-bank-fluid-data
spark-submit --driver-class-path $APP_DIR/config  --master "spark://demo-spark-cluster:7077"  --files $APP_DIR/config/app.conf,$APP_DIR/config/log4j.properties,$APP_DIR/jobs/sample_recon_job/data/recon-config.xml --class com.sapient.main.OpenBankApp $APP_DIR/lib/open-bank-fluid-data.jar $APP_DIR/jobs/sample_recon_job/data/recon-config.xml
