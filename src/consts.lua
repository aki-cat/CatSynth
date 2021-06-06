local Consts = {}

Consts.FPS = 120
Consts.FRAME_SIZE = 1 / Consts.FPS

Consts.SAMPLE_RATE = 44100
Consts.BUFFER_SIZE = 128
Consts.BUFFER_DURATION = Consts.BUFFER_SIZE / Consts.SAMPLE_RATE
Consts.BUFFERS_PER_SECOND = Consts.SAMPLE_RATE / Consts.BUFFER_SIZE
Consts.SECONDS_PER_SAMPLE = 1 / Consts.SAMPLE_RATE

return Consts
