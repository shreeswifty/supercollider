


(
    p=ProxySpace.push(s.reboot);
);

s.prepareForRecord("/tmp/test.flac");
s.record;
s.stopRecording;

// feedback synth ///////////////////////////////////////

(
    ~feedback.quant=1;
    ~feedback.fadeTime=5.002;
    ~feedback={
        var x,y,low,mid,high;

        // synths
        var mod = Duty.kr(4,0,Dseq([8,16,1.5*8,16,4,32,8*1.5,8],inf)).lag(1/8);
        var sig = SinOsc.ar(70.2*(1..8),mul:0.5);

        // mashing
        sig = CombN.ar(sig,0.5,LFSaw.ar(15000*LFSaw.ar(1/16/fib(8)).exprange(0.00001,1)*(1.01**(1..8))).exprange(0.0001,1),4);


        // channel distribution
        x = Normalizer.ar(sig)/4;
        y = LFSaw.ar(43.2*mod/[1,1.5,1.25,1.125],mul:LFTri.ar(1/4/fib(4)).exprange(0.001,0.075));
        #x,y = Rotate2.ar(x,y,SinOsc.ar(LFTri.ar(1/16*fib(8)).exprange(4.001,7)/8pi));


        // filters, reverbs
        sig = Limiter.ar([]++x++y,0.95);
        sig = Resonz.ar(sig,1900*LFSaw.ar(1/4/fib(8)).exprange(0.0001,1)+40);
        sig = FreeVerb2.ar(x,y,0.133,0.04);
        sig = GVerb.ar(sig,30,4,0.01,0.95,65);

        // compressor
        low = CompanderD.ar(LPF.ar(sig,200),4/3,1/3,1/2);
        mid = CompanderD.ar(BPF.ar(sig,400,2),4/3,1/2,1/2);
        high = CompanderD.ar(HPF.ar(sig,14200),4/3,1/1.1,1/2);
        sig = CompanderD.ar((high+mid+low).flat,4/3,1/1.1,1/1.1);

        Splay.ar(sig,0.95,0.25);
    };
    ~feedback.play;
);
~feedback.stop(30);
~feedback.clear;

