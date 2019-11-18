## Desc: A script to run and profile `LV1.py` and `LV2.py`

import cProfile
import pstats
import matplotlib.pylab as p
import LV1
import LV2
import LV3
import LV4
import LV5 
import sys


cProfile.run("LV1.LV1()", "../Results/LV1_Prof.txt")
cProfile.run("LV2.LV2(1)", "../Results/LV2_Prof.txt")
cProfile.run("LV3.LV3(1)", "../Results/LV3_Prof.txt")
cProfile.run("LV4.LV4(1)", "../Results/LV4_Prof.txt")
cProfile.run("LV5.LV5(1)", "../Results/LV5_Prof.txt")

LV1Stats = pstats.Stats("../Results/LV1_Prof.txt")
LV2Stats = pstats.Stats("../Results/LV2_Prof.txt")
LV3Stats = pstats.Stats("../Results/LV3_Prof.txt")
LV4Stats = pstats.Stats("../Results/LV4_Prof.txt")
LV5Stats = pstats.Stats("../Results/LV5_Prof.txt")

print("#####################TOP 5 ROWS OF PROFILE#####################")
LV1Stats.strip_dirs().sort_stats("cumulative").print_stats(5)
print("#####################TOP 5 ROWS OF PROFILE#####################")
LV2Stats.strip_dirs().sort_stats("cumulative").print_stats(5)
print("#####################TOP 5 ROWS OF PROFILE#####################")
LV3Stats.strip_dirs().sort_stats("cumulative").print_stats(5)
print("#####################TOP 5 ROWS OF PROFILE#####################")
LV4Stats.strip_dirs().sort_stats("cumulative").print_stats(5)
print("#####################TOP 5 ROWS OF PROFILE#####################")
LV5Stats.strip_dirs().sort_stats("cumulative").print_stats(5)


















