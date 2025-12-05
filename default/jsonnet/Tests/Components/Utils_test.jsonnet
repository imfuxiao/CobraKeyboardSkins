local utils = import '../../Components/Utils.libsonnet';


assert utils.setColor('testColor', { light: '#FFFFFF', dark: '#000000' }, true) == { testColor: '#000000' } : 'setColor function failed for dark mode';
assert utils.setColor('testColor', { light: '#FFFFFF', dark: '#000000' }, false) == { testColor: '#FFFFFF' } : 'setColor function failed for light mode';

local testGeometryStyle = utils.newGeometryStyle('test', {
  buttonStyleType: 'geometry',
  insets: {
    top: 6,
    left: 3,
    bottom: 6,
    right: 3,
  },
  normalColor: [
    '#9bafd9',
    '#103783',
  ],
  highlightColor: [
    '#432371',
    '#faae7b',
  ],
  colorLocation: [
    0,
    1,
  ],
  colorStartPoint: {
    x: 0.5,
    y: 0,
  },
  colorEndPoint: {
    x: 0.5,
    y: 1,
  },
  colorGradientType: 'radial',
  cornerRadius: 6,
  borderSize: 3,
  borderColor: '#f5d7a1',
  normalLowerEdgeColor: '#f5d7a1',
  highlightLowerEdgeColor: '#552E5A',
  normalShadowColor: '#e60b09',
  highlightShadowColor: '#e60b09',
  shadowRadius: 2,
  shadowOffset: {
    x: 0,
    y: 3,
  },
  shadowOpacity: 0.8,
}, false);

local testSystemImageStyle = utils.newSystemImageStyle('testSystemImage', {
  systemImageName: 'star.fill',
  contentMode: 'scaleAspectFit',
  fontSize: 24,
  fontWeight: 'bold',
  insets: {
    top: 6,
    left: 3,
    bottom: 6,
    right: 3,
  },
  normalColor: { light: '#333333', dark: '#DDDDDD' },
  highlightColor: { light: '#0066CC', dark: '#66AAFF' },
}, true);

local textAssetImageStyle = utils.newAssetImageStyle('testAssetImage', {
  assetImageName: 'example_image',
  contentMode: 'scaleAspectFit',
  insets: {
    top: 6,
    left: 3,
    bottom: 6,
    right: 3,
  },
  normalColor: { light: '#333333', dark: '#DDDDDD' },
  highlightColor: { light: '#0066CC', dark: '#66AAFF' },
}, false);

local testFileImageStyle = utils.newFileImageStyle('testFileImage', {
  contentMode: 'scaleAspectFit',
  normalImage: {
    file: 'background',
    image: '01',
  },
  highlightImage: {
    file: 'background',
    image: '01',
  },
}, true);

local testTextStyle = utils.newTextStyle('testText', {
  text: 'Sample Text',
  fontSize: 16,
  fontWeight: 'medium',
  insets: {
    top: 6,
    left: 3,
    bottom: 6,
    right: 3,
  },
  normalColor: { light: '#333333', dark: '#DDDDDD' },
  highlightColor: { light: '#0066CC', dark: '#66AAFF' },
}, false);

{
  testGeometryStyle: testGeometryStyle,
  testSystemImageStyle: testSystemImageStyle,
  textAssetImageStyle: textAssetImageStyle,
  testFileImageStyle: testFileImageStyle,
  testTextStyle: testTextStyle,
}
