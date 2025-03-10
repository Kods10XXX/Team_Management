
import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Test } from '@nestjs/testing';
import { AuthService } from '../../../src/auth/auth/auth.service';

describe('test AuthService', () => {
    let authService: AuthService;
    
    class JwtServiceMock {
    }
    
    beforeEach(async () => {
        const JwtServiceProvider = { provide: JwtService, useClass: JwtServiceMock };
        
        const moduleRef = await Test.createTestingModule({ imports: [], controllers: [], providers: [
                AuthService,
                JwtServiceProvider
            ] }).compile();
        
        authService = moduleRef.get<AuthService>(AuthService);
    });
    
    test('AuthService business', async () => {
        // todo mock and test;
    });
});
