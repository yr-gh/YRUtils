# syntax validation
java -jar ~/softs/cromwell/womtool-79.jar validate ~/AutoBackup/Linux-Desktop/VSCode/Projects/wdl/multiFastqc.wdl

# JSON input generation
java -jar ~/softs/cromwell/womtool-79.jar inputs ~/AutoBackup/Linux-Desktop/VSCode/Projects/wdl/multiFastqc.wdl > ~/AutoBackup/Linux-Desktop/VSCode/Projects/wdl/multiFastqc_inputs.json

# execute
java -Dbackend.providers.Local.config.concurrent-job-limit=4 -jar ~/softs/cromwell/cromwell-79.jar run ~/AutoBackup/Linux-Desktop/VSCode/Projects/wdl/multiFastqc.wdl -i ~/AutoBackup/Linux-Desktop/VSCode/Projects/wdl/multiFastqc_inputs.json &>> ~/my_test/mink_dev_chip_fastqc.log
