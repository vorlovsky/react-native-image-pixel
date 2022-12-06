import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-image-pixel' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

interface ImageDescription {
  id: string;
  width: number;
  height: number;
}

interface PixelColor {
  hex: string;
  r: number;
  g: number;
  b: number;
  a: number;
}

const ImagePixel = NativeModules.ImagePixel
  ? NativeModules.ImagePixel
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function loadImage(path: string): Promise<ImageDescription> {
  return ImagePixel.loadImage(path);
}

export function unloadImage(id: string): Promise<void> {
  return ImagePixel.unloadImage(id);
}

export function getPixel(
  id: string,
  x: number,
  y: number,
  normalized: boolean = false
): Promise<PixelColor> {
  return ImagePixel.getPixel(id, x, y, normalized);
}
