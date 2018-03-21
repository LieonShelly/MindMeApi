@_exported import Vapor
import JWT
import Crypto

extension Droplet {
    public func setup() throws {
        try setupRoutes()
        // Do any additional droplet setup
    }
    
    public func createToken(_ str: String) throws -> String {
        guard let sig = self.signers?.first else {
          throw  Abort.unauthorized
        }
        
        let timeToLive = Date().addingTimeInterval(5 * 60.0)
        let claims: [Claim] = [
            ExpirationTimeClaim(date: timeToLive)
        ]
        let payload = JSON(claims)
        let jwt =  try JWT(payload: payload, signer: sig.value as Signer)
        return try jwt.createToken()
    }
    
    public func validateToken( _ token: String) throws {
        let jwt = try JWT(token: token)
        let publicKeyString = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtfv/Vvk4/oC4OIa1c/G+cz3gBKUyMgHLzF1Kbn8Irvstr/tRGC18KyvOdy3h5s95ZDXu1pbgp742AUgouDTBh2HvmPl7ilactTMP7YELAYrqpC/FowihGIc+SonMWpMdylaDWdusCbmrEReOvXSiuYxpgif6SfW3K37JBHdkKZNxAQeoDamvhznCD8cRywZIRktZtfOHkZeGfrogumRIGVzhelI13oHnwwbPSSNxRv4eYRmn9NyVI34kAs9XlPNWEocfUYAj0p8yk0G50HxoEsI8DuWfFwjLUnc/dfBhYNaX5qn6P3Cx3RB+C0mEN9CiMGLKyINPD6RGYd8eAb/gOwIDAQAB"
        let publicKey = publicKeyString.data(using: .utf8)
        let bytes =  publicKey!.makeBytes().base64Decoded
        let resKey = try RS256(key: bytes)
        try jwt.verifySignature(using: resKey)
        let date =  ExpirationTimeClaim(date: Date())
       try jwt.verifyClaims([date])
    }
}
