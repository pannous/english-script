#!/usr/bin/natlash

<script type="javascript">
 var context = new(window.audioContext || window.webkitAudioContext);
 var oscillator = context.createOscillator();
 oscillator.frequency.value = 200;
 oscillator.connect(context.destination);
 oscillator.noteOn(0);
 oscillator.noteOff(.1);
</script>
