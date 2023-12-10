//  ManageSubscriptionViewModel.swift
import StoreKit

class ManagerSubscriptionViewModel: ObservableObject {
    
    @Published var subscriptions = [Product]()
    @Published var purchasedSubscriptions = Set<String>()
    @Published var isLoading = false
    @Published var error: Error?
    
    init() {
        Task { await loadSubscriptions() }
    }
    
    // MARK: - Load Subscriptions function fetches available subscription products from the App Store.
    func loadSubscriptions() async {
        isLoading = true
        do {
            let products = try await Product.products(for: ["108"])
            await MainActor.run {
                self.subscriptions = products
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Purchase Handling -> Purchase function initiates a purchase and handles the result, including successfull purchases and pending states.
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
                case .success(let verification):
                    await handlePurchase(verification)
                case .pending:
                    // Handle pending state if needed
                    break
                default:
                    break
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
    }
    
    // MARK: - Purchase Verification -> Handle Purchase method verifies the transaction and finished it.
    private func handlePurchase(_ verification: VerificationResult<Transaction>) async {
        switch verification {
            case .verified(let transaction):
                await MainActor.run {
                    self.purchasedSubscriptions.insert(transaction.productID)
                }
                await transaction.finish()
            case .unverified:
                // Handle unverified transaction
                break
        }
    }
    
    // MARK: - Restoration of Puchases -> The restore purchase function restores any previous purchases.
    // This is particularly important for subscription-based apps where users might install the app on multiple device or reinstall it.
    func restorePurchases() async {
        let productIDs = ["com.chateth.Yogelix.subscription.108"]

        for productID in productIDs {
            let result = await Transaction.latest(for: productID)
            await handleRestoredTransactions(result)
        }
    }
    
    // MARK: - Handling Restored Transactions -> The method processes each restored transaction, ensuring the app recognizes the user's current subscription status.
    private func handleRestoredTransactions(_ result: VerificationResult<Transaction>?) async {
        guard let result = result else { return }

        switch result {
        case .verified(let transaction):
            await MainActor.run {
                self.purchasedSubscriptions.insert(transaction.productID)
            }
            await transaction.finish()
        case .unverified:
            // Handle unverified transactions if necessary
            break
        }
    }
    
    // MARK: - Checking Active Subscription -> The funtion checks for any active subscriptions the user might have.
    // This is crucial for unlocking features or content based on subscription status.
    func checkActiveSubscriptions() async {
        for await verificationResult in Transaction.currentEntitlements {
            switch verificationResult {
            case .verified(let transaction):
                if !transaction.isUpgraded {
                    _ = await MainActor.run {
                        self.purchasedSubscriptions.insert(transaction.productID)
                    }
                }
                // Assuming transaction.finish() does not throw an error
                await transaction.finish()
            case .unverified:
                // Handle unverified transactions if necessary
                break
            }
        }
    }
}
