#This is a test file

set val(chan) Channel/WirelessChannel ;#channel type
set val(prop) Propagation/TwoRayGround ;#radio-propogation model
set val(netif) Phy/WirelessPhy ;#network interface type
set val(mac) Mac/802_11 ;#Mac type
set val(ifq) Queue/DropTail/PriQueue ;#interface queue type
set val(ll) LL ;#link layer type
set val(ant) Antenna/OmniAntenna ;#antenna model
set val(ifqlen) 50 ;#max packet in ifq
set val(nn) 3 ;#number of mobilenodes
set val(rp) AODV ;#routing protocol
set val(x) 500 ;#X dimension of topography
set val(y) 400 ;#Y dimension of topography
set val(stop) 10


#cheduler object creation--------#

set ns [new Simulator]

# Creating trace file and nam file

set tracefd [open wireless1.tr w]
set namtrace [open wireless1.nam w]   

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]

# configure the nodes
        $ns node-config -adhocRouting $val(rp) \
                   -llType $val(ll) \
                   -macType $val(mac) \
                   -ifqType $val(ifq) \
                   -ifqLen $val(ifqlen) \
                   -antType $val(ant) \
                   -propType $val(prop) \
                   -phyType $val(netif) \
                   -channelType $val(chan) \
                   -topoInstance $topo \
                   -agentTrace ON \
                   -routerTrace ON \
                   -macTrace OFF \
                   -movementTrace ON
                   
## Creating node objects...        
for {set i 0} {$i < $val(nn) } { incr i } {
            set node_($i) [$ns node]     
      }
      for {set i 0} {$i < $val(nn)  } {incr i } {
            $node_($i) color black
            $ns at 0.0 "$node_($i) color black"
      }

# Provide initial location of mobile nodes
$node_(0) set X_ 50.0
$node_(0) set Y_ 75.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 200.0
$node_(1) set Y_ 250.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 300.0
$node_(2) set Y_ 100.0
$node_(2) set Z_ 0.0

# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
$ns initial_node_pos $node_($i) 30
}

# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}

# Ending nam and the simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 10.01 "puts \"end simulation\"; $ns halt"
#stop procedure:
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
exec nam wireless1.nam &
}

$ns run







