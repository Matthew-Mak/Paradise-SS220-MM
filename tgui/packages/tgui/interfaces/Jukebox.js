import { sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { useBackend } from '../backend';
import { Box, Button, Dropdown, Section, Knob, LabeledControls, LabeledList } from '../components';
import { Window } from '../layouts';

export const Jukebox = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    active,
    track_selected,
    track_length,
    track_beat,
    volume,
  } = data;
  const songs = flow([
    sortBy(
      song => song.name),
  ])(data.songs || []);
  return (
    <Window
      width={370}
      height={313}>
      <Window.Content>
        <Section
          title="Проигрыватель"
          buttons={(
            <Button
              icon={active ? 'pause' : 'play'}
              content={active ? 'Стоп' : 'Воспроизвести'}
              selected={active}
              onClick={() => act('toggle')} />
          )}>
          <LabeledList>
            <LabeledList.Item label="Трек">
              <Dropdown
                overflow-y="scroll"
                width="240px"
                options={songs.map(song => song.name)}
                disabled={active}
                selected={track_selected || "Выбрать трек"}
                onSelected={value => act('select_track', {
                  track: value,
                })} />
            </LabeledList.Item>
            <LabeledList.Item label="Длительность">
              {track_selected ? track_length : "Трек не выбран"}
            </LabeledList.Item>
            <LabeledList.Item label="Ритм">
              {track_selected ? track_beat : "Трек не выбран"}
              {track_beat === 1 ? " beat" : " beats"}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Параметры">
          <LabeledControls justify="center">
            <LabeledControls.Item label="Громкость">
              <Box position="relative">
                <Knob
                  size={3.2}
                  color={volume >= 50 ? 'red' : 'green'}
                  value={volume}
                  unit="%"
                  minValue={0}
                  maxValue={100}
                  step={1}
                  stepPixelSize={1}
                  disabled={active}
                  onDrag={(e, value) => act('set_volume', {
                    volume: value,
                  })} />
                <Button
                  fluid
                  position="absolute"
                  top="-2px"
                  right="-22px"
                  color="transparent"
                  icon="fast-backward"
                  onClick={() => act('set_volume', {
                    volume: "min",
                  })} />
                <Button
                  fluid
                  position="absolute"
                  top="16px"
                  right="-22px"
                  color="transparent"
                  icon="fast-forward"
                  onClick={() => act('set_volume', {
                    volume: "max",
                  })} />
                <Button
                  fluid
                  position="absolute"
                  top="34px"
                  right="-22px"
                  color="transparent"
                  icon="undo"
                  onClick={() => act('set_volume', {
                    volume: "reset",
                  })} />
              </Box>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
