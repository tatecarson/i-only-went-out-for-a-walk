
(
w = Window().front;
a = XSimpleButton.new.label_("Start").action_({ Tdef(\seq).play});
b = XSimpleButton.new.label_("Stop").action_({Tdef(\seq).stop; });
w.layout = VLayout(a, b);
);
