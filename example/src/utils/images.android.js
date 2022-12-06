import RNFS from 'react-native-fs';

export async function preloadImageFromBundle(fileName) {
  const tmpFilePath = `${RNFS.TemporaryDirectoryPath}/${fileName}`;

  // const dir = await RNFS.readDir(RNFS.TemporaryDirectoryPath);
  // dir.forEach(item => console.log(item.path));

  const tmpFileExists = await RNFS.exists(tmpFilePath);
  if (!tmpFileExists) {
    await RNFS.copyFileAssets(fileName, tmpFilePath);
  }

  return tmpFilePath;
}
