s.scope;
(
Ndef(\q,{
	Splay.ar(
		CombN.ar(
			Resonz.ar(
			Vibrato.ar(
			LFPulse.ar(432/[1,2]/pi,mul:0.4).lag(0.00001)-0.2;
				,[4,5,6,7],0.2)
			,432/2pi)
			,1,LFSaw.ar(1/64/[1,2]).range(0.0001,0.2),4).softclip.lag(0.001)
	)
}).play;
)