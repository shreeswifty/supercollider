QGui_Canvan : Window {

	classvar >thisClassDebugging = false;

	var fullscreen, minimize, normalRect,
	objects,
	<panelStages, <panelNodes, <panelMap;

	*new { | bounds |
		bounds.isNil.if(
			{ bounds = Rect(0,0,400,400).center_( Window.availableBounds.center ) },
			{ bounds = Window.flipY( bounds.asRect )}
		);
		^super.new.initWindow("Canvan", bounds, true, false, false ).init;
	}

	init {
		(QGui.debbuging and: thisClassDebugging).if({"\n% [%]".format(thisMethod, this.bounds).postln	});

		objects = Dictionary.new();
		// this.asView.minWidth_(400);
		// this.asView.minHeight_(200);
		panelMap = QGui_PanelMap(this, Rect(0,0,150,150)).name("panelMap");
		// panelStages = QGui_PanelStages(this).name_("panelStages");
		// panelNodes = QGui_PanelNodes(this).name_("panelNodes");
		this.refreshPanels;

		this.initControls;
		this.refreshCoor;

		this.onClose_{
			"CloseCanvan".postln;
			QGui.close;
		};

		this.asView.action_{
			"CanvanAction".warn;
			panelMap.doAction;
			panelStages.doAction;
			panelNodes.doAction;

			this.refreshPanels;
		};

		this.asView.onResize_{

			this.refreshCoor;
			this.refreshPanels;
		};

		this.drawFunc_{
			Pen.fillColor_(Color.new255(20,20,20));
			Pen.addRect(Rect.offsetEdgeTop(this.bounds, 0,0,0,45));
			Pen.addRect(Rect.offsetEdgeBottom(this.bounds, 0,0,0,45));
			Pen.fill;
			Pen.strokeColor_(Color.new255(60,60,60));
			Pen.addRect(Rect.offsetRect(this.bounds,0,0,0,0));
			Pen.stroke;
		};
	}

	refreshCoor{
		objects[\Button_Exit].bounds_(Rect.offsetCornerRT(this.bounds, 10,10,25,25));
		objects[\Button_Maximize].bounds_(Rect.offsetCornerRT(this.bounds, 40,10,25,25));
		objects[\Button_Minimize].bounds_(Rect.offsetCornerRT(this.bounds, 70,10,25,25));

		objects[\Logo].bounds_(Rect.offsetCornerLT(this.bounds, 12,12,50,20));
		objects[\Version].bounds_(Rect.offsetCornerRB(this.bounds, 12,13,60,20));

		objects[\Button_Map].bounds_(Rect.offsetCornerLB(this.bounds, 10,10,25,25));
		objects[\Button_Node].bounds_(Rect.offsetCornerLB(this.bounds, 40,10,25,25));
		objects[\Button_Time].bounds_(Rect.offsetCornerLB(this.bounds, 70,10,25,25));
	}

	refreshPanels{
		"Canvan.refreshPanels".warn;
		// panelMap.bounds_(Rect.offsetEdgeLeft(this.bounds, 10,50,50, 300));
		"jsem".warn;
		// panelStages.bounds_(Rect.offsetEdgeLeft(this.bounds, panelMap.bounds.width + 30,50,50,panelStages.bounds.width));
		// panelNodes.bounds_(Rect.offsetEdgeRight(this.bounds, 10,50,50, this.bounds.width - panelStages.bounds.width - 30));

	}

	initControls {
		QGui_ViewControl(this.view, [\left, \top, \right, \bottom]);

		objects.put(\Button_Exit, QGui_Button(this)
			.name_("ButtonExit")
			.iconName("ButtonExitGUI")
			.colorFrame_(Color.clear)
			.action_{|button| this.close }
		);

		objects.put(\Button_Maximize, QGui_Button(this)
			.name_("ButtonMaximize")
			.iconName("ButtonMaximizeGUI")
			.colorFrame_(Color.clear)
			.keepingState_(false)
			.action_{|button|
				(button.value == 1).if(
					{ this.fullScreen },
					{ this.endFullScreen }
				);
			}
		);
		objects.put(\Button_Minimize, QGui_Button(this)
			.name_("ButtonMinimize")
			.iconName("ButtonMinimizeGUI")
			.colorFrame_(Color.clear)
			.keepingState_(false)
			.action_{|button| this.minimize	}
		);

		objects.put(\Button_Map, QGui_Button(this)
			.name_("ButtonMap")
			.iconName("IconMap2")
			.colorFrame_(Color.clear)
			.action_{|button|
				"\n>>>Button_Map pressed %".format(button.value).postln;
				(button.value == 1).if(
					{ QGui.setDisplayPanel(\panelStages, true)},
					{ QGui.setDisplayPanel(\panelStages, false)}
				);
				panelStages.doAction;
			}
		);
		objects.put(\Button_Node, QGui_Button(this)
			.name_("ButtonNode")
			.iconName("IconNode")
			.colorFrame_(Color.clear)
			.action_{|button|
				"\n>>>Button_Node pressed %".format(button.value).postln;
				(button.value == 1).if(
					{ QGui.setDisplayPanel(\panelNodes, true)},
					{ QGui.setDisplayPanel(\panelNodes, false)}
				)
			}
		);
		objects.put(\Button_Time, QGui_Button(this)
			.name_("ButtonTime")
			.iconName("IconTime")
			.colorFrame_(Color.clear)
			.action_{|button|
				"\nTimePressed %".format(button.value).postln;
				(button.value == 1).if(
					{ QGui.setDisplayPanel(\panelMap, true)},
					{ QGui.setDisplayPanel(\panelMap, false)}
				)
			}
		);


		// REST ///////////////////////////////
		objects.put(\Logo, StaticText(this)
			.string_("QTools")
			.align_(\left)
			.font_(QGui.fonts[\Header])
			.stringColor_(Color.new255(20,180,240))
			// .palette_(QGui.qPalette);
		);

		objects.put(\Version, StaticText(this)
			.string_("version %".format(QTools.version))
			.align_(\right)
			.font_(QGui.fonts[\Small])
			.stringColor_(Color.new255(20,180,240))
			// .palette_(QGui.qPalette);
		);
	}

	decorator{ ^this.view.decorator }

}

