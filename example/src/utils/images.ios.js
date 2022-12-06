import RNFS from 'react-native-fs';

export async function preloadImageFromBundle(fileName) {
  return `${RNFS.MainBundlePath}/assets/${fileName}`;
}
