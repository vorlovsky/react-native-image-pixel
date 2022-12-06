import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import * as RNImagePixel from 'react-native-image-pixel';
import { preloadImageFromBundle } from './utils/images';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>();

  React.useEffect(() => {
    const process = async () => {
      try {
        const filePath = await preloadImageFromBundle('test_image.png');

        const { id } = await RNImagePixel.loadImage(filePath);
        console.log(id);

        let pixel = await RNImagePixel.getPixel(id, 100, 100);
        console.log(pixel);

        setResult(pixel.hex);

        pixel = await RNImagePixel.getPixel(id, 10, 10);
        console.log(pixel);

        await RNImagePixel.unloadImage(id);

        pixel = await RNImagePixel.getPixel(id, 10, 10);
        console.log(pixel);
      } catch (error) {
        console.log(error);
      }
    };

    process();
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: #{result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
