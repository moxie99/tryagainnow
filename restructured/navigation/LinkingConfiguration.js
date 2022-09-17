/**
 * Learn more about deep linking with React Navigation
 * https://reactnavigation.org/docs/deep-linking
 * https://reactnavigation.org/docs/configuring-links
 */

import { LinkingOptions } from '@react-navigation/native';
import * as Linking from 'expo-linking';

/** Hi, Segun!
 * I've commented this out. To use typescript, simply uncomment the import statement. 
 * Change the file to reflect .ts extension
 * 
 * Replace this line with line 18 --> // import { RootStackParamList } from '../types';
 * const linking: LinkingOptions<RootStackParamList> = {
*/ 

const linking = {
  prefixes: [Linking.makeUrl('/')],
  config: {
    screens: {
      Root: {
        screens: {
          IBoolaContract: {
            screens: {
              IBoolaContract: 'iBoolaContract',
            },
          },
          Account: {
            screens: {
              Account: 'account',
            },
          },
        },
      },
      Modal: 'modal',
      NotFound: '*',
    },
  },
};

export default linking;
