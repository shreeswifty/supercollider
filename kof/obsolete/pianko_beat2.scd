

(
~mod.quant=4;
~mod.mold(4);
~mod={Duty.kr([4,8,16,32],0,Dseq(powerset([1,1.25,1.5,2,4,3]).scramble.flat.pyramid.scramble,inf))};


~md.quant=4;
~md.mold(4);
~md={Duty.kr([4,8,16,32]*2,0,Dseq(powerset([1,1.25,1.125,1.5,2,0.75,0.5]).scramble.flat.pyramid.scramble,inf))};


~md3.quant=4;
~md3.mold(4);
~md3={Duty.kr([4,8,16,32]*4,0,Dseq(powerset([1,1.25,1.125,1.5,0.75,0.5]).scramble.flat.pyramid.scramble,inf))};


~mod2.quant=4;
~mod2.mold(1);
~mod2={Duty.kr(4,0,Dseq(powerset([2,1.5,1,4,0.5,1.5]).scramble.flat.pyramid,inf))};

)

(

~a.play;
~a.quant = 4;

~a = {
	var sig,t,env,mel;

	t = Impulse.ar(1/4,1/8*[0,1,2,3,5,4,6,7,7.25,7.5,7.75]+TExpRand.ar(0.00001,0.005,Impulse.ar(1)));
	env = Decay.ar(t,1.45);
	sig = SinOsc.ar(43.2 * (env.sqrt*1.5+1),mul:0.25 ) * env;

	t = Impulse.ar(1/4,1/8*([0,1,2,3,4,5,6,7,7.25,7.5]+0.5));
	env = Decay.ar(t,0.25);

	sig = BPF.ar(BrownNoise.ar(0.4!2) * env,TExpRand.ar(8000,18000,t)-(1+env.sqrt*4000)) + sig;


	t = Impulse.ar(1/2,1/8*([0,1,2,3,0,2,6]+TExpRand.ar(0.00001,0.05,Impulse.ar(1))));
	env = Decay.ar(t,1.25+TExpRand.ar(0.5,(1..3),t));
	mel = 43.202*2*((~mod2)*[1pi,0.5pi,2pi,0.25pi])/~mod;
	sig = RLPF.ar(LFSaw.ar(mel*(1.00001**(1..11))+SinOsc.ar(1/4/fib(11)).range(0,1.5),mul:0.64*TExpRand.ar(0.25,1,t)) * env,mel*(env.sqrt)) + sig;


	t = Impulse.ar(1/4,1/8*([0,2,4,6]));
	env = Decay.ar(t,3.75+TExpRand.ar(0.5,(1..4),t));
	mel = 43.2021*2*((~mod2)*[0.5pi,1pi])/~md;
	sig = RLPF.ar(LFSaw.ar(mel*(1.0001**(1..11))+SinOsc.ar(1/fib(11,1,3)),mul:0.54*TExpRand.ar(0.25,1,t)) * env,mel*(env.sqrt)) + sig;

	t = Impulse.ar(1,1/8*([0,2,4,6]+4));
	env = Decay.ar(t,0.95+TExpRand.ar(0.5,(1..4),t));
	mel = 43.20213*1*((~mod2)*[1pi,2pi])/~md3;
	sig = RLPF.ar(LFSaw.ar(mel*(1.000001**(1..11))+SinOsc.ar(1/fib(11,1,2)),mul:0.44*TExpRand.ar(0.25,1,t)) * env,mel*(env.sqrt)) + sig;



	sig = Vibrato.ar(sig,[4,5,6,7],0.04);
	// sig = CombN.ar(sig,0.025,4,8);
	sig = CompanderD.ar(sig,0.85,1/1.5,1/10);
	sig = FreeVerb.ar(sig,0.13,0.5);

	Splay.ar(sig,0.45,1);
};
)