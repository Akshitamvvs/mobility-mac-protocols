set opt(chan) Channel/WirelessChannel
set opt(prop) Propagation/TwoRayGround
set opt(netif) Phy/WirelessPhy

set opt(mac) Mac/SMAC ;
set opt(ifq) Queue/DropTail/PriQueue
set opt(ll) LL
set opt(ant) Antenna/OmniAntenna
set opt(x) 800;# X dimension of the topography
set opt(y) 800;# Y dimension of the topography
set opt(cp) "../mobility/scene/cbr-50-10-4-512"
set opt(sc) "../mobility/scene/scen-670x670-50-600-20-0"
set opt(ifqlen) 50;# max packet in ifq
set opt(nn) 2;# number of nodesset opt(seed)0.0
set opt(stop) 700.0;# simulation time
set opt(tr) MyTest.tr;# trace files
set nam MyTest.nam;# animation file
set opt(rp) DumbAgent ;# routing protocol scripts
set opt(lm) "off" ;# log movement
set opt(agent) Agent/DSDV
set opt(energymodel) EnergyModel
#set opt(energymodel) RadioModel
set opt(radiomodel) RadioModel
set opt(initialenergy) 1000 ;# Initial energy in Joules#
set opt(logenergy) "on" ;# log energy every 150 seconds

Mac/SMAC set syncFlag_ 1
Mac/SMAC set dutyCycle_ 10

set ns_ [new Simulator]
set topo [new Topography]
set tracefd [open $opt(tr) w]
set prop [new $opt(prop)]



$topo load_flatgrid $opt(x) $opt(y)
ns-random 1.0
$ns_ trace-all $tracefd

create-god $opt(nn)


$ns_ node-config -adhocRouting DumbAgent \
		 -llType $opt(ll) \
		 -macType $opt(mac) \
		 -ifqType $opt(ifq) \
		 -ifqLen $opt(ifqlen) \
		 -antType $opt(ant) \
		 -propType $opt(prop) \
		 -phyType $opt(netif) \
		 -channelType $opt(chan) \
		 -topoInstance $topo \
		 -agentTrace ON \
		 -routerTrace ON \
		 -macTrace ON \
 		 -energyModel $opt(energymodel) \
		 -idlePower 1.0 \
		 -rxPower 1.0 \
		 -txPower 1.0 \
		 -sleepPower 0.001 \
		 -transitionPower 0.2 \
		 -transitionTime 0.005 \
		 -initialEnergy $opt(initialenergy)

$ns_ set WirelessNewTrace_ ON
#set AgentTraceON
#set RouterTraceOFF
#set MacTraceON

	for {set i 0} {$i < $opt(nn) } {incr i} {
		set node_($i) [$ns_ node]
		$node_($i) random-motion 0;# disable random motion
	}


set udp_(0) [new Agent/UDP]
$ns_ attach-agent $node_(0) $udp_(0)
set null_(0) [new Agent/Null]
$ns_ attach-agent $node_(1) $null_(0)
set cbr_(0) [new Application/Traffic/CBR]

$cbr_(0) set packetSize_ 512
$cbr_(0) set interval_ 10.0
$cbr_(0) set random_ 1
$cbr_(0) set maxpkts_ 50000
$cbr_(0) attach-agent $udp_(0)
$ns_ connect $udp_(0) $null_(0)

$ns_ at 1.00 "$cbr_(0) start"


for {set i 0} {$i < $opt(nn) } {incr i} {
$ns_ at $opt(stop) "$node_($i) reset";
}
$ns_ at $opt(stop) "puts \"NS EXITING...\" ; $ns_ halt"

#--------------------
proc stop {} {
    
    exec nam Mytest.nam &
 
}
#------------------------

set b [$node_(0) set mac_(0)]
#set c [$b set freq_]
set d [Mac/SMAC set syncFlag_]

#set e [$node_(0) set netif_(0)] 
#set c [$e set L_]

set c [Mac/SMAC set dutyCycle_]

puts "Starting Simulation..."
$ns_ run







