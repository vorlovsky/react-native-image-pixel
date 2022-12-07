
# react-native-image-pixel

  

Allows to get RGBA pixel data from a local raster image file

  

## Installation

```sh
npm install react-native-image-pixel
```
or

```sh
yarn add react-native-image-pixel
```

  

## Usage

```js
import  *  as  RNImagePixel  from  'react-native-image-pixel';

// ...

const IMAGE_FILE_PATH = '/some/local/path/image.png';

// loading image
const {id, width, height} = await loadImage(IMAGE_FILE_PATH);

// ...

const normalized = true; // flag value that points if x and y are in the range of [0...width] and [0...height] respectively (for non-normalized) or [0...1] (for normalized)

let x = 100;
let y = 100;

if(normalized) {
	x /= width;
	y /= height; 
}

// getting pixel color components (r,g,b,a) and hex representation string (hex)
const {r, g, b, a, hex} = await getPixel(id, x, y, normalized);

// ...

// unloading image
await unloadImage(id);
```
NB: see the sources in `example/src/utils` folder for a possible solution  to load images from app assets/bundle.



## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

  

## License

MIT

  
---
