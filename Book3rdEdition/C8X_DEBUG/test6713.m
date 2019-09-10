C8X_DEBUG('debug');
C8X_DEBUG('init', 5, 3);
C8X_DEBUG('version');
C8X_DEBUG('run', 'TalkThru_6713.out');
Gain = [0 0];
C8X_DEBUG('rfs', Gain, '_Gain', 2);
Gain
pause
Gain = [0.5 2.0];
C8X_DEBUG('wfs', Gain, '_Gain', 2);
pause
Gain = [2.0 0.5];
C8X_DEBUG('wfs', Gain, '_Gain', 2);
pause
C8X_DEBUG('silent');
C8X_DEBUG('reset');

