QuantNode {
	classvar version = 0.10;
	// var <>key;
	// var stage, phase;
	var <>nodeName;
	// , <>slot;
	var <qObjects;
	// var >levels, >times, >curves;
	var <node, <prewNode;
	var group, bus;
	var clock;

	*new {|proxy, slot, phase, qObject| ^super.new.init(proxy, slot, phase, qObject);	}
	// *new2 {|key, quant, fadeTime| ^super.new.init(key, quant, fadeTime);	}

	init{|proxy, slot, phase, qObject|

		// this.slot = slot;
		qObjects.isNil.if(
			{
				qObjects = MultiLevelIdentityDictionary.new();
				nodeName = proxy.envirKey;
				group = proxy.group;
				"\nQuantNode init nodeName[%]".format(nodeName).postln;
			},
			{ "QuantNode nodeName % exist".format(nodeName)  }
		);
		// qObjects.put(proxy, slot, phase, qObject);
		this.addObject(slot, phase, qObject);

		// this.print;
	}

	addObject{|slot, phase, qObject|
		var key = qObject.key;
		// UPRAVIT MAPU NA -> KEY / SLOT
		//                        / PHASE / CURRENTOBJECT
		//                                / PREVIOUSOBJECT
		//                        / GROUP


		// "QuantNode addObject nodeName:%".format(nodeName);
		// "QuantNode addObject proxy.envirKey:%".format(nodeName);
		// "QuantNode addObject qObjects: %".format(qObjects).postln;
		"\nQuantNode addObject [nodeName:%, slot:%, phase:%, qObject:%]".format(nodeName, slot, phase, qObject).postln;
		qObjects.at(nodeName, slot, phase, \current).notNil.if({
			qObjects.put(nodeName, slot, phase, \previous, qObjects.at(nodeName, slot, phase, \current));
		});
		qObjects.put(nodeName, slot, phase, \current, qObject);
	}

	removeObject {|slot, phase, getCurrent|
		getCurrent.if(
			{ qObjects.removeEmptyAt(nodeName, slot, phase, \current); },
			{ qObjects.removeEmptyAt(nodeName, slot, phase, \previous); }
		)
	}

	/*
	init2{|key, quant, fadeTime|
	var instance;
	this.key = key;

	instance = QuantMap.currentNode;
	"instance: %".format(instance).postln;
	instance.isNil.if(
	{
	var defValue = QuantMap.currentProxy.getDefaultVal(key.asSymbol);
	// "% defValue: %".format(QuantMap.currentProxy.envirKey, defValue).postln;

	instance = this;
	node = NodeProxy.control(Server.local, 1);
	node.set(key.asSymbol, defValue); // ?? jak udelat fade z tyhle hodnoty

	clock = TempoClock.new();
	clock.permanent = true;
	},
	{
	node = instance.node;
	}
	);

	node.fadeTime = fadeTime;
	node.quant = quant;

	QuantMap.add(instance);
	^instance;
	}
	*/
	print{
		"\nQuantNode print".postln;
		// "init QuantNode %".format(QuantMap.findProxy(this)).postln;
		// "\t - key : %".format(key).postln;
		// "\t - quant : %".format(node.quant).postln;
		// "\t - fadeTime : %".format(node.fadeTime).postln;
		// "\t - levels : %".format(levels).postln;
		// "\t - times : %".format(times).postln;
		// "\t - curves : %".format(curves).postln;
		// "\t - bus : %".format(node.bus).postln;

		"proxy : %".format(nodeName).postln;
		// "\t - slot : %".format(slot).postln;

		qObjects.sortedTreeDo(
			// {|proxy| proxy.notEmpty.if({"\nproxy ~%".format(proxy).postln;}); },
			{},
			{|path, qObject|
				var proxy = path[0];
				var slot = path[1];
				var phase = path[2];
				var objNewOld = path[3];
				// path.postln;
				// item.postln;
				"\t[%, %, %] QObject[%, levels%, times%, curves%]"
				.format(slot, phase, objNewOld, qObject.key, qObject.envelope.levels, qObject.envelope.times, qObject.envelope.curves).postln;
				// "\t[%] item : % (%)".format(slot, item, item.key).postln;
			},
			{},
			// {|node| node.notEmpty.if({"-----------".postln;})},
			{},
			{}
		);

		^nil;
	}

	// stop { clock.clear; }
	/*
	env { |env|
	var proxy = currentEnvironment.at(QuantMap.findProxy(this).asSymbol);
	var synthDef, synth;

	node.group = proxy.group;

	synthDef = SynthDef(
	"qNode [ %, q%, c% ]".format(key, node.quant, node.index),
	{
	Out.kr(node.index, EnvGen.kr(env, doneAction:2))
	}
	).add;


	this.stop;

	"time2quant [%]".format(this.time2quant(node.quant)).postln;

	// t = TempoClock.default.sched(time2quant, {
	clock.sched(this.time2quant(node.quant), {

	node.source = synthDef;
	// "objects[index].synthDef.func: %".format(node.objects[0].synthDef.func).postln;
	// "\ntick quant [%]".format(node.quant).postln;
	// "\t-cBusIndex [%]".format(node.index).postln;
	// "\t-nodeNameDef [%]".format(synthDef.name).postln;
	// "\t-cBusChannels [%]".format(node.numChannels).postln;
	// "\t-nodeID [%]".format(node.nodeID).postln;
	// "\t-envDuration [%]".format(env.duration).postln;

	proxy.set(key.asSymbol, node);

	node.quant;
	});

	}
	time2quant{|quant|
	if(currentEnvironment === topEnvironment)
	{ ^TempoClock.default.timeToNextBeat(quant); }
	{ ^currentEnvironment.at(\tempo).clock.timeToNextBeat(quant); };
	}
	*/



}