C8X_DEBUG('debug');
C8X_DEBUG('init', 40, 2);
C8X_DEBUG('version');
C8X_DEBUG('run', 'TalkThru_OMAP.out');
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

