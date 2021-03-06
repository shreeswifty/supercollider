


// one synth ///////////////////////////////////////

(
    ~one.ar(2);
    ~one.quant=2;
    ~one.fadeTime=4;
    ~one={
        var tem = 1/16;
        var mod = Duty.kr(4,0,Dseq([1,2,1,4,1,1.5],inf));
        var t = LFSaw.ar([1,1/4/[1,2,3,4],LFSaw.ar(1/5000).range(1,50)]) + LFSaw.ar(1/4000) * 40;
        var sig = Perlin3.ar(t[0],t[1],t[2]) * Decay.ar(Impulse.ar(8/[1,2,3,4]),0.02);
        var freqs = [50,500,250,750,500,1000,75,100,200,1500];
        var f = 1/TChoose.kr(Impulse.kr(tem/[1,2,4,1.5]),freqs).lag(1/2);// + (Pulse.ar(4/[1,2,3,4],mul:1/100000));
        sig = LocalIn.ar(4) + sig;
        sig = BPF.ar(sig,TChoose.kr(Impulse.kr(tem/[1,2,4,1.5]),freqs).lag(1),0.12);
        sig = DelayN.ar(sig,f,f) * LFTri.ar(tem/[1,2,4,1.5]).range(0.5,1);
        LocalOut.ar(sig/1.0000001);
        sig = CompanderD.ar(sig,3/4,1/3,1/2);
        Splay.ar(sig,0.95,0.25,SinOsc.kr(2/[5,6]));
    };
    ~one.play;
);
~one.stop(4);
~one.clear;
~one.pause;
~one.resume;



(
    p.clock.tempo_(120/60);

    ~offset = {(0..7)/8};

    ~tick.quant = 1;
    ~tick = {Mix(Impulse.kr( ~tempo / 2 , ~offset ))};

    ~counter = {PulseCount.kr(~tick.kr)};
);


// hiss synth ///////////////////////////////////////

(
    ~hiss.ar(2);
    ~hiss.quant=2;
    ~hiss.fadeTime=0.2;
    ~hiss={
        //         |       |       |       |       |  
        var pat = [1,0,0,0,1,0,0,0,1,0,0,0,1,0,1,0].rotate(1);
        var imp = PulseDivider.kr(~tick.kr,[1,2,3],~counter.kr);
        var hit = Select.kr(PulseCount.kr(imp)%pat.size,pat);
        var env = EnvGen.ar(Env([0.001,1,0.0001],[0.002,0.5],[3,-3],curve:'exp'),imp * hit);
        var sig = Crackle.ar([0.1,0.2,0.6]+env);
        sig = sig * env;
        Splay.ar(sig,0.25,0.095);
    };
    ~hiss.play;
);
~hiss.stop(4);
~hiss.clear;
~hiss.pause;
~hiss.resume;


// kick synth ///////////////////////////////////////

(
    ~kick.ar(2);
    ~kick.quant=2;
    ~kick.fadeTime=0.2;
    ~kick={
        //         |       |       |       |       |  
        var pat = [
            1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,
            1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,
            1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,
            1,1,0,0,1,0,0,0,1,0,0,0,1,0,1,0,
        ].rotate(3);
        var imp = PulseDivider.kr(~tick.kr,1,~counter.kr);
        var hit = Select.kr(PulseCount.kr(imp)%pat.size,pat);
        var env = EnvGen.ar(Env([0.001,1,0.0001],[0.002,2.5],[3,-3],curve:'exp'),imp * hit);
        var sig = SinOsc.ar(50!2,env**20*8pi);
        sig = sig * env;
        Splay.ar(sig,0.75,0.25);
    };
    ~kick.play;
);
~kick.stop(4);
~kick.clear;
~kick.pause;
~kick.resume;





// ff filter ///////////////////////////////////////

(
    ~ff.quant=1;
    ~ff.fadeTime=1;
    ~ff={
        var synths = p.playingProxies;
        var high,mid,low;
        var sig = [];
        var mod = Duty.kr(4,0,Dseq([1,2,1.5,1.33333],inf));
        synths.collect{|n| if(n!=\ff){sig=sig++p.[n.asSymbol];}};

        //sig = Resonz.ar(sig,MouseX.kr(100,10000,(1..8)),MouseY.kr(0.1,1,(1..4)/16))/4;
        //sig = CombN.ar(sig,1/50/mod,1/5/mod,4)+sig;
        //sig = GVerb.ar(LPF.ar(sig,4000)+HPF.ar(sig,350),[90,100],[6,6],spread:[95,96])/4 + sig;
        sig = LPF.ar(DWGReverb.ar(NumChannels.ar(sig,2),[4000,4010]),2000);
        low = CompanderD.ar(LPF.ar(sig,LFNoise2.kr(1/12!2).range(100,1800)),3/4,1,1/3);
        mid = CompanderD.ar(BPF.ar(sig,LFNoise2.kr(1/12!2).range(700,8000),0.2),3/4,1/1.3,1/3);
        high = CompanderD.ar(HPF.ar(sig,LFNoise2.kr(1/12!2).range(1000,14000)),3/4,1,1/3);
        sig = CompanderD.ar((high+mid+low).flat,LFNoise2.kr(1/4).range(0.4,0.8),1,1/2,0.002,0.3);
        Splay.ar(sig,0.75,0.75);
    };
    ~ff.play;
);
~ff.stop(7);
~ff.clear;
