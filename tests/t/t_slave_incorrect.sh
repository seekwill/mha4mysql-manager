. ./init.sh

mysql $S1 -e "stop slave io_thread"

for i in $S2P $S3P $S4P
do
mysql -h127.0.0.1 -P$i -e "set global relay_log_purge=0"
mysql -h127.0.0.1 -P$i test -e "flush logs"
mysql -h127.0.0.1 -P$i test -e "flush logs"
mysql -h127.0.0.1 -P$i test -e "flush logs"
mysql -h127.0.0.1 -P$i test -e "flush logs"
mysql -h127.0.0.1 -P$i test -e "flush logs"
done

mysql $M test -e "insert into t1 values(2, 200, 'aaaaaa')"

mysql $S3  -e "stop slave; reset slave; change master to master_log_file=''"

masterha_check_repl --conf=$CONF > /dev/null 2>&1
fail_if_zero $0 $?

./run.sh
fail_if_zero $0 $?

./kill_m.sh

masterha_check_repl --conf=$CONF > /dev/null 2>&1
fail_if_zero $0 $?
./run.sh
fail_if_zero $0 $?

echo "$0 [Pass]"

