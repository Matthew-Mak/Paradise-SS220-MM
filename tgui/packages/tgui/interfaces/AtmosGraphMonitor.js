import { useBackend, useLocalState } from '../backend';
import { Section, Box, Tabs, Icon } from '../components';
import { Window } from '../layouts';
import { pureComponentHooks } from '../../common/react';
import { zipWith, map } from '../../common/collections';
import { Component, createRef } from 'inferno';
import { toFixed } from '../../common/math';

export const AtmosGraphMonitor = (props, context) => {
  const { act, data } = useBackend(context);
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);
  const decideTab = (index) => {
    switch (index) {
      case 0:
        return (
          <AtmosGraphPage
            data={data}
            info="Интервал записи T = 20 с. | Интервал между записями t = 1с."
            pressureListName="pressure_history"
            temperatureListName="temperature_history"
          />
        );
      case 1:
        return (
          <AtmosGraphPage
            data={data}
            info="Интервал записи T = 300 с. (5 Мин) | Интервал между записями t = 15с."
            pressureListName="long_pressure_history"
            temperatureListName="long_temperature_history"
          />
        );

      default:
        return "WE SHOULDN'T BE HERE!";
    }
  };
  const maxWingowHeight = 800;
  const getWindowHeight = Math.min(
    maxWingowHeight,
    Object.keys(data.sensors).length * 220 + 150
  );
  return (
    <Window width={700} height={getWindowHeight}>
      <Window.Content scrollable>
        <Box fillPositionedParent>
          <Tabs>
            <Tabs.Tab
              key="View"
              selected={tabIndex === 0}
              onClick={() => setTabIndex(0)}
            >
              <Icon name="area-chart" /> Текущие
            </Tabs.Tab>
            <Tabs.Tab
              key="History"
              selected={tabIndex === 1}
              onClick={() => setTabIndex(1)}
            >
              <Icon name="bar-chart" /> История
            </Tabs.Tab>
          </Tabs>
          {decideTab(tabIndex)}
        </Box>
      </Window.Content>
    </Window>
  );
};

const AtmosGraphPage = ({
  data,
  info,
  pressureListName,
  temperatureListName,
}) => {
  let sensors_list = data.sensors || {};

  const getLastReading = (sensor, listName) =>
    sensors_list[sensor][listName].slice(-1)[0];
  const getMinReading = (sensor, listName) =>
    Math.min(...sensors_list[sensor][listName]);
  const getMaxReading = (sensor, listName) =>
    Math.max(...sensors_list[sensor][listName]);
  const getDataToSensor = (sensor, listName) =>
    sensors_list[sensor][listName].map((value, index) => [index, value]);

  return (
    <Box>
      <Section color={'gray'}>{info}</Section>
      {Object.keys(sensors_list).map((s) => (
        <Section key={s} title={s}>
          <Section px={2}>
            {/* ТЕМПЕРАТУРА */}
            {temperatureListName in sensors_list[s] && (
              <Box mb={2}>
                <Box>
                  {'Температура: ' +
                    toFixed(getLastReading(s, temperatureListName), 0) +
                    'К (MIN: ' +
                    toFixed(getMinReading(s, temperatureListName), 0) +
                    'К;' +
                    ' MAX: ' +
                    toFixed(getMaxReading(s, temperatureListName), 0) +
                    'К)'}
                </Box>
                <Section fill height={5} mt={1}>
                  <AtmosChart
                    fillPositionedParent
                    data={getDataToSensor(s, temperatureListName)}
                    rangeX={[
                      0,
                      getDataToSensor(s, temperatureListName).length - 1,
                    ]}
                    rangeY={[0, getMaxReading(s, temperatureListName) + 5]}
                    strokeColor="rgba(219, 40, 40, 1)"
                    fillColor="rgba(219, 40, 40, 0.1)"
                  />
                </Section>
              </Box>
            )}

            {/* ДАВЛЕНИЕ */}
            {pressureListName in sensors_list[s] && (
              <Box mb={-1}>
                <Box>
                  {'Давление: ' +
                    toFixed(getLastReading(s, pressureListName), 0) +
                    'кПа (MIN: ' +
                    toFixed(getMinReading(s, pressureListName), 0) +
                    'кПа;' +
                    ' MAX: ' +
                    toFixed(getMaxReading(s, pressureListName), 0) +
                    'кПа)'}
                </Box>
                <Section fill height={5} mt={1}>
                  <AtmosChart
                    fillPositionedParent
                    data={getDataToSensor(s, pressureListName)}
                    rangeX={[
                      0,
                      getDataToSensor(s, pressureListName).length - 1,
                    ]}
                    rangeY={[0, getMaxReading(s, pressureListName) + 5]}
                    strokeColor="rgba(40, 219, 40, 1)"
                    fillColor="rgba(40, 219, 40, 0.1)"
                  />
                </Section>
              </Box>
            )}
          </Section>
        </Section>
      ))}
    </Box>
  );
};

// Ниже находится код вдохновленный компонентом CHART.JS
// К удалению, если будут приняты изменения в официальном компоненте

const normalizeData = (data, scale, rangeX, rangeY) => {
  if (data.length === 0) {
    return [];
  }
  const min = zipWith(Math.min)(...data);
  const max = zipWith(Math.max)(...data);
  if (rangeX !== undefined) {
    min[0] = rangeX[0];
    max[0] = rangeX[1];
  }
  if (rangeY !== undefined) {
    min[1] = rangeY[0];
    max[1] = rangeY[1];
  }
  const normalized = map((point) => {
    return zipWith((value, min, max, scale) => {
      return ((value - min) / (max - min)) * scale;
    })(point, min, max, scale);
  })(data);
  return normalized;
};

const dataToPolylinePoints = (data) => {
  let points = '';
  for (let i = 0; i < data.length; i++) {
    const point = data[i];
    points += point[0] + ',' + point[1] + ' ';
  }
  return points;
};

class AtmosChart extends Component {
  constructor(props) {
    super(props);
    this.ref = createRef();
    this.state = {
      // Initial guess
      viewBox: [400, 800],
    };
    this.handleResize = () => {
      const element = this.ref.current;
      this.setState({
        viewBox: [element.offsetWidth, element.offsetHeight],
      });
    };
  }

  componentDidMount() {
    window.addEventListener('resize', this.handleResize);
    this.handleResize();
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize);
  }
  render() {
    const {
      data = [],
      rangeX,
      rangeY,
      fillColor = 'none',
      strokeColor = '#ffffff',
      strokeWidth = 2,
      ...rest
    } = this.props;
    const { viewBox } = this.state;
    const normalized = normalizeData(data, viewBox, rangeX, rangeY);
    // Push data outside viewBox and form a fillable polygon
    if (normalized.length > 0) {
      const first = normalized[0];
      const last = normalized[normalized.length - 1];
      normalized.push([viewBox[0] + strokeWidth, last[1]]);
      normalized.push([viewBox[0] + strokeWidth, -strokeWidth]);
      normalized.push([-strokeWidth, -strokeWidth]);
      normalized.push([-strokeWidth, first[1]]);
    }
    const points = dataToPolylinePoints(normalized);
    const horizontalLinesCount = 2; // Горизонтальные линии сетки, не имеют физического смысла
    const verticalLinesCount = data.length - 2;
    const gridColor = 'rgba(255, 255, 255, 0.1)';
    const gridWidth = 2;
    const pointTextColor = 'rgba(255, 255, 255, 0.8)';
    const pointTextSize = '0.8em';
    const labelViewBoxSize = 400;

    return (
      <Box position="relative" {...rest}>
        {(props) => (
          <div ref={this.ref} {...props}>
            <svg
              viewBox={`0 0 ${viewBox[0]} ${viewBox[1]}`}
              preserveAspectRatio="none"
              style={{
                position: 'absolute',
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                overflow: 'hidden',
              }}
            >
              {/* Горизонтальные линии сетки */}
              {Array.from({ length: horizontalLinesCount }).map((_, index) => (
                <line
                  key={`horizontal-line-${index}`}
                  x1={0}
                  y1={(index + 1) * (viewBox[1] / (horizontalLinesCount + 1))}
                  x2={viewBox[0]}
                  y2={(index + 1) * (viewBox[1] / (horizontalLinesCount + 1))}
                  stroke={gridColor}
                  strokeWidth={gridWidth}
                />
              ))}
              {/* Вертикальные линии сетки */}
              {Array.from({ length: verticalLinesCount }).map((_, index) => (
                <line
                  key={`vertical-line-${index}`}
                  x1={(index + 1) * (viewBox[0] / (verticalLinesCount + 1))}
                  y1={0}
                  x2={(index + 1) * (viewBox[0] / (verticalLinesCount + 1))}
                  y2={viewBox[1]}
                  stroke={gridColor}
                  strokeWidth={gridWidth}
                />
              ))}
              {/* Полилиния графика */}
              <polyline
                transform={`scale(1, -1) translate(0, -${viewBox[1]})`}
                fill={fillColor}
                stroke={strokeColor}
                strokeWidth={strokeWidth}
                points={points}
              />
              {/* Точки */}
              {data.map(
                (point, index) =>
                  index % 2 === 1 && (
                    <circle
                      key={`point-${index}`}
                      cx={normalized[index][0]}
                      cy={viewBox[1] - normalized[index][1]}
                      r={2} // радиус точки
                      fill="#ffffff" // цвет точки
                      stroke={strokeColor} // цвет обводки
                      strokeWidth={1} // ширина обводки
                    />
                  )
              )}
              {/* Значения точек */}
              {data.map(
                (point, index) =>
                  viewBox[0] > labelViewBoxSize &&
                  index % 2 === 1 && (
                    <text
                      key={`point-text-${index}`}
                      x={normalized[index][0]}
                      y={viewBox[1] - normalized[index][1]}
                      fill={pointTextColor}
                      fontSize={pointTextSize}
                      dy="1em" // Сдвиг текста вниз, чтобы он не перекрывал точку
                      dx="-2.5em" // Сдвиг текста влево
                      textAnchor="middle" // Центрирование текста по x координате
                    >
                      {point[1] !== null ? point[1].toFixed(0) : 'N/A'}
                    </text>
                  )
              )}
            </svg>
          </div>
        )}
      </Box>
    );
  }
}

AtmosChart.defaultHooks = pureComponentHooks;
