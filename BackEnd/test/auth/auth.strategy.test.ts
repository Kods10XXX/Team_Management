
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { OIDCStrategy } from 'passport-azure-ad';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { AzureStrategy } from '../../src/auth/auth.strategy';

describe('test AzureStrategy', () => {
    let azureStrategy: AzureStrategy;
    
    class ConfigServiceMock {
    }
    
    beforeEach(async () => {
        const ConfigServiceProvider = { provide: ConfigService, useClass: ConfigServiceMock };
        
        const moduleRef = await Test.createTestingModule({ imports: [], controllers: [], providers: [
                AzureStrategy,
                ConfigServiceProvider
            ] }).compile();
        
        azureStrategy = moduleRef.get<AzureStrategy>(AzureStrategy);
    });
    
    test('AzureStrategy business', async () => {
        // todo mock and test;
    });
});
