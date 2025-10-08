// IPFS Upload Script for IDIOT Token Audit Logs - Updated for Pinata SDK v2
import { PinataSDK } from 'pinata';
import fs from 'fs';
import dotenv from 'dotenv';

dotenv.config();

async function uploadToIPFS() {
    console.log('🌐 Uploading IDIOT Token audit logs to IPFS via Pinata SDK v2...\n');
    
    const pinataJwt = process.env.PINATA_JWT; // Your JWT token
    const pinataGateway = process.env.NEXT_PUBLIC_GATEWAY_URL; // Your gateway URL
    
    if (!pinataJwt) {
        console.log('❌ Pinata JWT not found');
        console.log('Set PINATA_JWT to your Pinata JWT token');
        console.log('\nTo get your JWT:');
        console.log('1. Go to Pinata dashboard');
        console.log('2. Go to API Keys');
        console.log('3. Create new key or use existing');
        console.log('4. Copy the JWT token (starts with eyJ...)');
        return;
    }
    
    console.log(`🔑 Using Pinata JWT: ${pinataJwt.substring(0, 20)}...`);
    
    try {
        // Initialize Pinata SDK
        const pinata = new PinataSDK({
            pinataJwt: pinataJwt,
            pinataGateway: pinataGateway || 'gateway.pinata.cloud'
        });
        
        // Upload audit log file
        const auditFile = 'audit/vesting_verification_log.md';
        if (fs.existsSync(auditFile)) {
            console.log('📤 Uploading audit log file...');
            
            const fileStream = fs.createReadStream(auditFile);
            const options = {
                metadata: {
                    name: 'IDIOT-Token-Vesting-Verification',
                    keyvalues: {
                        project: 'IDIOT Token',
                        type: 'audit-log',
                        timestamp: new Date().toISOString(),
                        network: 'Base Mainnet'
                    }
                },
                options: {
                    cidVersion: 0
                }
            };
            
            const result = await pinata.upload.public.file(fileStream, options);
            
            console.log('✅ Audit log uploaded successfully!');
            console.log(`📁 IPFS Hash: ${result.IpfsHash}`);
            console.log(`🔗 Pinata Gateway: https://gateway.pinata.cloud/ipfs/${result.IpfsHash}`);
            console.log(`🌐 Public Gateway: https://ipfs.io/ipfs/${result.IpfsHash}`);
        } else {
            console.log('⚠️ Audit log file not found, skipping...');
        }
        
        // Upload audit summary JSON
        const auditSummary = {
            project: 'IDIOT Token',
            type: 'audit-summary',
            timestamp: new Date().toISOString(),
            network: 'Base Mainnet',
            tokenAddress: '0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1',
            verificationStatus: 'completed',
            files: {
                auditLog: 'vesting_verification_log.md',
                description: 'IDIOT Token vesting wallet verification and audit log'
            }
        };
        
        console.log('\n📤 Uploading audit summary JSON...');
        
        const jsonOptions = {
            metadata: {
                name: 'IDIOT-Token-Audit-Summary',
                keyvalues: {
                    project: 'IDIOT Token',
                    type: 'audit-summary',
                    timestamp: new Date().toISOString()
                }
            },
            options: {
                cidVersion: 0
            }
        };
        
        const jsonResult = await pinata.upload.public.json(auditSummary, jsonOptions);
        
        console.log('✅ Audit summary uploaded successfully!');
        console.log(`📁 IPFS Hash: ${jsonResult.IpfsHash}`);
        console.log(`🔗 Pinata Gateway: https://gateway.pinata.cloud/ipfs/${jsonResult.IpfsHash}`);
        console.log(`🌐 Public Gateway: https://ipfs.io/ipfs/${jsonResult.IpfsHash}`);
        
        console.log('\n🎉 IPFS upload process completed!');
        console.log('Your audit logs are now permanently stored on IPFS!');
        
    } catch (error) {
        console.error('❌ Error uploading to IPFS:', error.message);
        console.log('\nTroubleshooting:');
        console.log('1. Check your Pinata JWT token');
        console.log('2. Ensure you have the correct permissions');
        console.log('3. Verify your internet connection');
        process.exit(1);
    }
}

uploadToIPFS().catch(console.error);