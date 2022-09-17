import { useWalletConnect } from "@walletconnect/react-native-dapp";
import { StyleSheet } from "react-native";
import { RootStackScreenProps } from "../types";
import { Text, View, TouchableOpacity } from "../components/Themed";
import Colors from "../constants/Colors";

/**
 * We will use the wallet connect system.
 * Make the login route to this page.
 * What we need here is line `17` So that when user clicks on login or connect wallet,
 * the function "connector.connect()" is called.
 *              ==================== 
 */
export default function LoginScreen({
	navigation,
}: RootStackScreenProps<"Root">) {
	const connector = useWalletConnect();
	return (
		<View style={styles.container}>
			<TouchableOpacity onPress={() => connector.connect()}>
				<Text style={{ fontSize: 16 }}>Connect Wallet</Text>
			</TouchableOpacity>
		</View>
	);
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		alignItems: "center",
		justifyContent: "center",
	},
	title: {
		fontSize: 20,
		fontWeight: "bold",
	},
});
