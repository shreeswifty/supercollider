JMix_v011 {
	classvar version = 0.11;
	classvar server;

	classvar mixSDef, efxSDef;

	var <coll_Channels;
	var numCh;
	var <synG, mixG;
	var master_Synth, master_aBus;

	*new { |numChannels|
		^super.new.init(numChannels);
	}

	init { |xCh|

		server = Server.default;
		mixSDef = this.storeSynth(this.folderMix); // Mix_Fader = 0; Mix_Limiter = 1
		efxSDef = this.storeSynth(this.folderEfx);

		server.waitForBoot{
			numCh = xCh;

			synG = Group.new;
			mixG = Group.new(addAction:\addToTail);

			master_aBus = Bus.audio(server, 2);
			master_Synth = Synth(this.mixSynthDef(1),[\bus, master_aBus],mixG);

			coll_Channels = List.new(numCh);
			numCh.do { |i|
				coll_Channels.add(JMix_channel(this, i));
			};
		}
	}

	storeSynth {|dir, libname=\global, completionMsg, keepDef = true|
		var dict, list;
		dict = IdentityDictionary.new;
		(dir ++ "\/*.scd").pathMatch.do{ |path|
			dict.put(path.basename.splitext[0].asSymbol, 0);
		};

		dict.keysDo{|key|
			if(dict[key]==0){
				dict[key] = thisProcess.interpreter.compileFile("%\/%.scd".format(dir, key)).value;
			};
		};

		dict.do{|def|
			def.add(libname, completionMsg, keepDef);
		};

		list = dict.keys(Array);
		list.sort;
		("list of prepared synth: " ++ list).postln;
		^list;
	}

	gui {
		var win;
		var sizeXChnl, sizeYChnl;
		var colBack, colFront, colActive;
		var fontBig, fontSmall;

		sizeXChnl = 65;
		sizeYChnl = 400;
		colBack = Color.new255(30,30,30);
		colFront = Color.new255(255,255,255);
		colActive = Color.new255(200,50,50);
		fontBig = Font("Segoe UI", 7,true, isPointSize:true);
		fontSmall = Font("Segoe UI", 6, isPointSize:true);

		win = Window.new("ja_Mixer v"++version, Rect(900,600,5+((sizeXChnl+5)*numCh),410))
		.alpha_(0.95)
		.alwaysOnTop_(true)
		.background_(colBack)
		.front;

		numCh.do { |i|
			var uv, originX, originY;

			originX = 5+((sizeXChnl+5)*i);
			originY = 5;

			uv = UserView(win, Rect(originX, originY, sizeXChnl, sizeYChnl))
			.background_(colBack)
			.drawFunc = {
				Pen.strokeColor = colFront;
				Pen.addRect(Rect(0,0, uv.bounds.width,uv.bounds.height));

				Pen.addRect(Rect(5,45, uv.bounds.width-22,80)); // fqv frame

				Pen.moveTo(5@133);
				Pen.lineTo(uv.bounds.width-5@133);
				Pen.moveTo(5@160);
				Pen.lineTo(uv.bounds.width-5@160);
				Pen.stroke;
			};

			this.channel(i).gui(uv, originX, originY, colBack, colFront, colActive, fontBig, fontSmall);




		};

		win.onClose_({
			numCh.do { |i|
				this.channel(i).free;
			};
			win.close;
			"JMix closed".postln;
		});

	}

	mixSynthDef {|num| ^mixSDef[num];}
	efxSynthDef {|num| ^efxSDef[num];}
	ch{ |num| ^coll_Channels[num].audioBus; }
	channel{ |num| ^coll_Channels[num]; }
	audioBus { ^master_aBus; }

	folderRoot{ ^Platform.systemExtensionDir ++ "\/JMix"; }
	folderMix{ ^this.folderRoot ++ "\/Mix"; }
	folderEfx{ ^this.folderRoot ++ "\/Efx"; }

}

JMix_channel{
	classvar server, master;
	classvar chnlG;
	classvar numEfx;

	var id;
	var faderSynth;
	var aBus;
	var cb_amp, cb_mute;

	var uv;
	var name, txtAmp, fqv;
	var valAmp, sliderAmp, buttMute;

	*new{ |mix, xID|
		^super.new.init(mix, xID);
	}

	init { |mix, xID|
		id = xID;
		server = Server.default;
		master = mix;
		chnlG = Group.new(master.synG, \addAfter);

		aBus = Bus.audio(server, 2);
		cb_amp = Bus.control(server, 1).value_(0);
		cb_mute = Bus.control(server, 1).value_(1);

		faderSynth = Synth(master.mixSynthDef(0), [
			\in, aBus,
			\out, master.audioBus,
			\amp, cb_amp.asMap,
			\mute, cb_mute.asMap,
		], chnlG,\addToTail);

		this.buildEfx;
	}

	buildEfx{

	}

	gui{ |uv, originX, originY, colBack, colFront, colActive, fontBig, fontSmall|

		name = StaticText.new(uv,Rect(5, 5, uv.bounds.width-5, 12))
		.string_("ch["++id++"]")
		.stringColor_(colFront)
		.font_(fontBig);

		txtAmp = StaticText.new(uv,Rect(5, 22, 20, 15))
		.string_("amp:")
		.stringColor_(colFront)
		.font_(fontSmall);

		fqv = FreqScopeView(uv, Rect(5,45, uv.bounds.width-22,80));
		fqv.active_(true);
		fqv.inBus_(aBus);
		fqv.freqMode_(1);
		fqv.background_(Color.black);

		valAmp = NumberBox(uv, Rect(27, 23, 20, 15))
		.normalColor_(colFront)
		.background_(colBack)
		.align_(\center)
		.font_(fontSmall);

		sliderAmp = Slider(uv, Rect(uv.bounds.width-13, 5, 8, 120))
		.background_(colBack)
		.knobColor_(colActive)
		.action_({
			valAmp.value = sliderAmp.value;
			cb_amp.value = sliderAmp.value;
		});

		buttMute = Button(uv, Rect(27, 5, 20, 15))
		.font_(fontSmall)
		.valueAction_(cb_mute.value)
		.states_([
			["||",colFront,colBack],
			[">",colFront,colActive]
		])
		.action_({ |butt|
			if(butt.value == 1) { cb_mute.value = 1; };
			if(butt.value == 0) { cb_mute.value = 0; };
		});
	}

	free{
		fqv.kill // !!! nutne bez ";"
	}

	audioBus { ^aBus; }
	amp_cBus { ^cb_amp; }
	amp_cBus_ { |newValue| cb_amp.value = newValue; }
	mute_cBus { ^cb_mute; }
	mute_cBus_ { |newValue| cb_mute.value = newValue; }


}