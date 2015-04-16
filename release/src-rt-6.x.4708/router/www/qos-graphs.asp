<!--
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/

For use with Tomato Firmware only.
No part of this file may be used without permission.
--><title>View Graphs</title>
<content>
	<style type="text/css">
		.color {
			width: 12px;
			height: 25px;
		}
		.title {
			padding: 0 5px;
		}
		.count {
			text-align: right;
		}
		.pct {
			width:55px;
			text-align: right;
		}
		.thead {
			font-size: 90%;
			font-weight: 500;
		}
		.total {
			border-top: 1px dashed #bbb;
			font-weight: 500;
			margin-top: 5px;
		}

		.embedGraph {
			text-align: center;
		}
	</style>
	<script type="text/javascript">
		// <% nvram("qos_classnames,web_svg,qos_enable"); %>

		//<% qrate(); %>

		var svgReady = 0;

		var Unclassified = ['Unclassified'];
		var classNames = nvram.qos_classnames.split(' ');		// Toastman - configurable class names
		var abc = Unclassified.concat(classNames);

		var colors = [
			'c6e2ff',
			'b0c4de',
			'9ACD32',
			'3cb371',
			'6495ed',
			'8FBC8F',
			'a0522d',
			'deb887',
			'F08080',
			'ffa500',
			'ffd700'
		];

		function mClick(n)
		{
			loadPage('#qos-detailed.asp', 'class=' + n);
		}

		function showData()
		{
			var i, n, p;
			var ct, rt;

			ct = rt = 0;
			for (i = 0; i < 11; ++i) {
				if (!nfmarks[i]) nfmarks[i] = 0;
				ct += nfmarks[i];
				if (!qrates[i]) qrates[i] = 0;
				rt += qrates[i];
			}

			for (i = 0; i < 11; ++i) {
				n = nfmarks[i];
				E('ccnt' + i).innerHTML = n;
				if (ct > 0) p = (n / ct) * 100;
				else p = 0;
				E('cpct' + i).innerHTML = p.toFixed(2) + '%';
			}
			E('ccnt-total').innerHTML = ct;

			for (i = 1; i < 11; ++i) {
				n = qrates[i];
				E('bcnt' + i).innerHTML = (n / 1000).toFixed(2)
				E('bcntx' + i).innerHTML = (n / 8192).toFixed(2)
				if (rt > 0) p = (n / rt) * 100;
				else p = 0;
				E('bpct' + i).innerHTML = p.toFixed(2) + '%';
			}
			E('bcnt-total').innerHTML = (rt / 1000).toFixed(2)
			E('bcntx-total').innerHTML = (rt / 8192).toFixed(2)
		}


		var ref = new TomatoRefresh('update.cgi', 'exec=qrate', 2, 'qos_graphs');

		ref.refresh = function(text)
		{
			nfmarks = [];
			qrates = [];
			try {
				eval(text);
			}
			catch (ex) {
				nfmarks = [];
				qrates = [];
			}

			showData();
			if (svgReady == 1) {
				updateCD(nfmarks, abc);
				updateBD(qrates, abc);
			}
		}

		function checkSVG()
		{
			var i, e, d, w;

			try {
				for (i = 1; i >= 0; --i) {
					e = E('svg' + i);
					d = e.getSVGDocument();
					if (d.defaultView) w = d.defaultView;
					else w = e.getWindow();
					if (!w.ready) break;
					if (i == 0) updateCD = w.updateSVG;
					else updateBD = w.updateSVG;
				}
			}
			catch (ex) {
			}

			if (i < 0) {
				svgReady = 1;
				updateCD(nfmarks, abc);
				updateBD(qrates, abc);
			}
			else if (--svgReady > -5) {
				setTimeout(checkSVG, 500);
			}
		}

		function init() {

			// Write Graphs to content
			for (i=0; i < 2; i++) {
				$('#svg-'+i).html('<embed id="svg' + i + '" type="image/svg+xml" pluginspage="http://www.adobe.com/svg/viewer/install/" src="img/qos-graph.svg?n=' + i + '&v=<% version(); %>" style="width:310px;height:310px;"></embed>').css('text-align', 'center');
			}

			nbase = fixInt(cookie.get('qnbase'), 0, 1, 0);
			showData();
			checkSVG();
			// showGraph();
			ref.initPage(2000, 3);
		}
	</script>

	<script type="text/javascript">
		if (nvram.qos_enable != '1') {
			$('.container .ajaxwrap').prepend('<div class="alert alert-info"><b>QoS is disabled.</b>&nbsp; <a class="ajaxload" href="qos-settings.asp">Enable &raquo;</a> <a class="close"><i class="icon-cancel"></i></a></div>');
		}
	</script>

	<div class="fluid-grid x3">

		<div class="box graphs">
			<div class="heading">Connections Distribution</div>
			<div class="content">
				<div id="svg-0" class="embedGraph"></div>

				<table id="firstTable">
					<tr><td>&nbsp;</td><td class="total">Total</td><td id="ccnt-total" class="total count"></td><td class="total pct">100%</td></tr>
				</table>

				<script type="text/javascript">
					for (i = 0; i < 11; ++i) {
						$('#firstTable').prepend('<tr style="cursor:pointer" onclick="mClick(' + i + ')">' +
							'<td class="color" style="background:#' + colors[i] + '" onclick="mClick(' + i + ')">&nbsp;</td>' +
							'<td class="title" style="width:60px">' + abc[i] + '</td>' +
							'<td id="ccnt' + i + '" class="count" style="width:90px"></td>' +
							'<td id="cpct' + i + '" class="pct"></td></tr>');
					}
				</script>
			</div>
		</div>

		<div class="box graphs last">
			<div class="heading">Bandwidth Distribution (Outbound)</div>
			<div class="content">
				<div id="svg-1" class="embedGraph"></div>

				<table id="secondTable">
					<tr><td class="color" style="height:1em; margin-right: 5px;"></td><td class="title">&nbsp;</td><td class="thead count">kbit/s</td><td class="thead count">KB/s</td><td class="thead pct">Rate</td></tr>
					<tr><td>&nbsp;</td><td class="total">Total</td><td id="bcnt-total" class="total count"></td><td id="bcntx-total" class="total count"></td><td id="rateout" class="total pct"></td></tr>
				</table>

				<script type='text/javascript'>
					for (i = 1; i < 11; ++i) {
						$('#secondTable').prepend('<tr style="cursor:pointer" onclick="mClick(' + i + ')">' +
							'<td class="color" style="background:#' + colors[i] + '" onclick="mClick(' + i + ')">&nbsp;</td>' +
							'<td class="title" style="width:45px">' + abc[i] + '</td>' +
							'<td id="bcnt' + i + '" class="count" style="width:60px"></td>' +
							'<td id="bcntx' + i + '" class="count" style="width:50px"></td>' +
							'<td id="bpct' + i + '" class="pct"></td></tr>');
					}
				</script>
			</div>
		</div>

	</div>

	<script type="text/javascript">$('.box.last').after(genStdRefresh(1,2,"ref.toggle()"));</script>
	<script type="text/javascript">init();</script>
</content>