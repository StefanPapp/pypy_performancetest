import datetime

from ctext import run_test

start_cleanup = datetime.datetime.now()
run_test()
end = datetime.datetime.now()
duration = end - start_cleanup
print "DONE  done in: " + str(duration)
