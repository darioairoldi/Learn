---
title: "External User Types and Invitation Process in Azure AD/Entra ID"
author: "Dario Airoldi"
date: "2025-11-02"
categories: [Azure AD, Entra ID, B2B, Guest Users, Identity]
description: "Understanding different external user identity types in Azure AD/Entra ID and the invitation redemption process for proper guest user management."
format:
  html:
    toc: true
    toc-depth: 3
    number-sections: true
    code-fold: true
---

## Table of Contents

- [🔑 Understanding External User Types](#-understanding-external-user-types)
  - [ExternalAzureAD Identity Type](#externalazuread-identity-type)
  - [Mail Identity Type](#mail-identity-type)
  - [Microsoft Account (MSA) Identity Type](#microsoft-account-msa-identity-type)
  - [Social Identity Providers](#social-identity-providers)
- [📬 The Invitation and Redemption Process](#-the-invitation-and-redemption-process)
  - [Invitation Flow Overview](#invitation-flow-overview)
  - [Redemption Methods and Their Impact](#redemption-methods-and-their-impact)
  - [Critical Decision Point: Authentication Method](#critical-decision-point-authentication-method)
- [⚙️ Capabilities and Limitations by Identity Type](#️-capabilities-and-limitations-by-identity-type)
  - [ExternalAzureAD Capabilities](#externalazuread-capabilities)
  - [Mail Identity Limitations](#mail-identity-limitations)
  - [Microsoft Account Considerations](#microsoft-account-considerations)
- [✅ Best Practices for Guest User Management](#-best-practices-for-guest-user-management)
  - [Ensuring Proper Identity Federation](#ensuring-proper-identity-federation)
  - [Troubleshooting Common Issues](#troubleshooting-common-issues)
  - [Organizational Policies](#organizational-policies)
- [📚 Appendix: Technical Details](#-appendix-technical-details)
  - [Appendix A: User Principal Name (UPN) Formats](#appendix-a-user-principal-name-upn-formats)
  - [Appendix B: Invitation API Behavior](#appendix-b-invitation-api-behavior)
  - [Appendix C: Conditional Access and Guest Users](#appendix-c-conditional-access-and-guest-users)
- [🔗 References](#-references)

---

## 🔑 Understanding External User Types

<mark>Azure AD</mark> (now <mark>Microsoft Entra ID</mark>) supports <mark>multiple types of external users</mark>, each with **different characteristics**, **capabilities**, and **limitations**. 

The <mark>identity type</mark> of a guest user determines how they authenticate and what resources they can access.

### ExternalAzureAD Identity Type

**<mark>ExternalAzureAD** represents the most robust type of external user account. 

These users are federated with their home Azure AD tenant and maintain their organizational identity.

**Characteristics:**
- **<mark>User Principal Name (UPN)</mark>**: `user@externaldomain.com#EXT#@hostingtenant.onmicrosoft.com`
- **<mark>Authentication**: Performed against the user's home Azure AD tenant
- **<mark>Identity Source**: External Azure AD organization
- **<mark>Federation**: Fully federated with the source tenant

**How it's created:**
This identity type is created <mark>when a guest user redeems an invitation using their organizational work or school account from an Azure AD-backed organization</mark>. The redemption must occur through Microsoft Entra authentication flow (typically steps 1-5 in the invitation flow diagram).

### Mail Identity Type

**<mark>Mail** identity type represents a simplified guest account that relies on email-only verification without a backing Microsoft or organizational account.

**Characteristics:**
- **<mark>User Principal Name (UPN)**: `user_externaldomain.com@guest.hostingtenant.com`
- **<mark>Authentication**: Email one-time passcode (OTP) or similar email-based verification
- **<mark>Identity Source**: Email address only
- **<mark>Federation**: No federation with external tenant

> **📝 Note on UPN Format Variations:**  
> The UPN format for Mail identity type can vary depending on your tenant's configuration:
> 
> - **Standard Microsoft Format**: `user_externaldomain.com#EXT#@hostingtenant.onmicrosoft.com`  
>   (e.g., `john_contoso.com#EXT#@fabrikam.onmicrosoft.com`)
> 
> - **Custom Guest Domain Format**: `user_externaldomain.com@guest.hostingtenant.com`  
>   (e.g., `john_contoso.com@guest.fabrikam.com`)
> 
> The format shown above reflects a custom guest domain configuration. Some organizations configure custom verified domains for guest accounts for branding, governance, or compliance purposes. The key identifier for Mail identity type is:
> - The `@` symbol in the original email is replaced with `_` (underscore)
> - No federation with the user's email domain
> - Authentication relies on email OTP, regardless of UPN format

**How it's created:**
This identity type is created when:
1. A guest redeems an invitation using <mark>email one-time passcode authentication</mark>
2. The guest doesn't have or <mark>doesn't use a Microsoft account or Azure AD account</mark> during redemption
3. <mark>The organization has email OTP enabled as a fallback authentication method</mark>

### Microsoft Account (MSA) Identity Type

**<mark>Microsoft Account** represents users who authenticate using a <mark>personal Microsoft account</mark> (e.g., @outlook.com, @hotmail.com, or a personal email registered as an MSA).

**Characteristics:**
- **User Principal Name (UPN)**: `user_domain.com#EXT#@hostingtenant.onmicrosoft.com`
- **Authentication**: Microsoft Account authentication system
- **Identity Source**: Microsoft consumer identity platform
- **Federation**: Federated with Microsoft Account system, not an organizational tenant

**How it's created:**
<mark>Created when a user redeems an invitation using their personal Microsoft account credentials</mark>.

### Social Identity Providers

<mark>Azure AD B2B</mark> also supports <mark>social identity providers</mark> (<mark>Google</mark>, <mark>Facebook</mark>, etc.) if configured.

**Characteristics:**
- **<mark>Authentication**: Through the configured social identity provider
- **<mark>Identity Source**: Social provider (Google, Facebook, etc.)
- **<mark>Federation**: Limited; relies on the social provider's authentication

**How it's created:**
Only available if the <mark>hosting tenant has explicitly configured and enabled social identity providers in their External Identities settings</mark>.

---

## 📬 The Invitation and Redemption Process

The invitation redemption process is critical in determining the resulting guest user identity type. Understanding this flow helps administrators ensure guests obtain the correct identity type for their organizational needs.

### Invitation Flow Overview

The invitation process follows these key stages:

<img src="images/01.002 Invitation flow.png" alt="Invitation Flow Diagram" width="600" style="border: 2px solid #ddd; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); margin: 10px 0;">

**Stage 1: Invitation Creation**
- Administrator creates a guest user invitation in Azure AD
- Invitation email is sent to the external user's email address
- Invitation contains a redemption URL with a unique token

**Stage 2: Invitation Email Received**
- Guest user receives email with invitation link
- Email typically contains information about the inviting organization
- Link directs to the redemption flow

**Stage 3: Redemption Initiation**
- Guest user clicks the invitation link
- Azure AD begins the redemption process
- System attempts to identify the user's existing identity

### Redemption Methods and Their Impact

The diagram illustrates different redemption paths:

**Path 1-5: Azure AD Federated Authentication (Recommended)**
1. User clicks invitation link
2. Redirected to Microsoft authentication page
3. **CRITICAL**: User must authenticate with their organizational (Azure AD) work or school account
4. Home tenant (e.g., sensorfact.nl) validates the user
5. Guest account created with **ExternalAzureAD** identity type
   - **Result**: Fully federated guest user
   - **Authentication**: Through home organization's Azure AD
   - **Identity**: Maintains organizational identity

**Alternative Path: Email One-Time Passcode**
1. User clicks invitation link
2. User chooses "Use email one-time passcode" or doesn't have an Azure AD account
3. System sends OTP to email address
4. User enters OTP code
5. Guest account created with **Mail** identity type
   - **Result**: Non-federated guest user
   - **Authentication**: Email OTP only
   - **Identity**: Email-based, no organizational backing

**Alternative Path: Microsoft Account**
1. User clicks invitation link
2. User signs in with personal Microsoft account
3. Guest account created with **Microsoft Account** identity type
   - **Result**: MSA-backed guest user
   - **Authentication**: Through Microsoft consumer identity
   - **Identity**: Personal Microsoft account

### Critical Decision Point: Authentication Method

The key decision point occurs at **Step 3** in the flow. The user must:

✅ **DO**: 
- Open invitation in a **private/incognito browser window**
- Sign in with their **organizational work or school account**
- Ensure they're authenticated to their home Azure AD tenant
- Complete the redemption while maintaining that session

❌ **DON'T**:
- Use email one-time passcode if an organizational account is available
- Sign in with a personal Microsoft account when an organizational account exists
- Accept invitation while signed into the wrong tenant or account

---

## ⚙️ Capabilities and Limitations by Identity Type

Different external user identity types have varying levels of functionality within the hosting organization.

### ExternalAzureAD Capabilities

**Full Functionality:**
- ✅ **<mark>Microsoft Teams Access**: Full Teams application authentication and functionality
- ✅ **<mark>SharePoint and OneDrive**: Complete file access and collaboration features
- ✅ **<mark>Azure AD Application Access**: Can authenticate to Azure AD-integrated apps
- ✅ **<mark>Conditional Access**: Subject to both home and host tenant policies
- ✅ **<mark>Multi-Factor Authentication (MFA)**: Honors home tenant MFA policies
- ✅ **<mark>Single Sign-On (SSO)**: Seamless authentication across Microsoft services
- ✅ **<mark>Privileged Access**: Can be granted elevated permissions if needed

**Security Features:**
- Identity managed by home organization
- Password policies enforced by home tenant
- Account lifecycle managed by home organization
- Audit logs available in both tenants

**Use Cases:**
- Long-term business partnerships
- Regular collaboration on Teams and SharePoint
- Access to line-of-business applications
- Projects requiring compliance and security controls

### Mail Identity Limitations

**Limited Functionality:**
- ⚠️ **<mark>Microsoft Teams**: May experience authentication failures or <mark>limited functionality</mark>
- ⚠️ **<mark>Application Access**: Many Azure AD-integrated apps may not authenticate properly
- ⚠️ **<mark>Conditional Access**: Limited ability to enforce complex policies
- ⚠️ **<mark>MFA**: Cannot leverage organizational MFA; relies on email verification only
- ⚠️ **<mark>SSO**: No seamless authentication; requires repeated email OTP entry
- ❌ **<mark>Privileged Access**: <mark>Generally not suitable for elevated permissions</mark>

**Security Concerns:**
- No organizational backing or identity management
- Relies solely on email account security
- No password policy enforcement
- Limited audit trail capabilities
- Email compromise = account compromise

**Use Cases:**
- One-time or very limited access scenarios
- External users without organizational Azure AD accounts
- Simple file sharing without application integration
- Short-term access needs

### Microsoft Account Considerations

**Moderate Functionality:**
- ✅ **Basic Microsoft Services**: Can access basic Microsoft 365 services
- ⚠️ **Teams and Apps**: May work, but not recommended for organizational use
- ⚠️ **Security Controls**: Limited organizational control
- ✅ **MFA**: Can use Microsoft Account MFA if configured

**Concerns:**
- Personal account used for business purposes
- Limited organizational oversight
- Consumer-grade security policies
- Mixing personal and business identity

**Use Cases:**
- Rare; generally not recommended for business collaboration
- May be acceptable for very casual, non-sensitive scenarios
- Better alternatives usually available (ExternalAzureAD or Mail)

---

## ✅ Best Practices for Guest User Management

### Ensuring Proper Identity Federation

**For Administrators:**

1. **Pre-Invitation Communication**
   - Inform guests about the proper redemption process
   - Provide clear instructions to use organizational accounts
   - Explain the importance of authentication method selection

2. **Verification Process**
   - After invitation redemption, verify the guest user's identity type
   - Check the user object in Azure AD for the `userType` and identity source
   - Confirm UPN format matches expected pattern for ExternalAzureAD

3. **Remediation Steps**
   - If wrong identity type is created:
     - Delete the guest user account
     - Resend invitation with clear instructions
     - Consider having a call with the guest to guide through redemption

4. **Configuration Settings**
   - Review External Identities settings in Entra ID
   - Configure appropriate authentication methods
   - Consider disabling email OTP for scenarios requiring federated identities
   - Set up access packages for standardized onboarding

### Troubleshooting Common Issues

**Issue: "Account does not exist in tenant" Error**

**Symptom:** Guest user receives error when accessing Teams or Azure AD apps, stating their account doesn't exist in the hosting tenant.

**Root Cause:** User account created with **Mail** identity type instead of **ExternalAzureAD**.

**Resolution:**
1. Verify identity type in Azure AD user properties
2. Delete the existing guest account
3. Resend invitation
4. Guide user to redeem using organizational account in private browser window
5. Verify new guest account has ExternalAzureAD identity type

**Issue: Guest Cannot Access Teams Application**

**Symptom:** Authentication failures or access denied when using Teams.

**Root Cause:** Non-federated identity type (Mail or MSA) attempting Teams access.

**Resolution:**
1. Confirm this is a federated requirement for your Teams usage
2. Recreate guest with proper ExternalAzureAD identity
3. Ensure Teams licensing and permissions are correctly configured

**Issue: Guest User Receives Repeated OTP Prompts**

**Symptom:** User must enter email OTP frequently, disrupting workflow.

**Root Cause:** User has Mail identity type, causing email-based authentication.

**Resolution:**
1. If user has organizational account: recreate with ExternalAzureAD identity
2. If user lacks organizational account: consider if they need extended access
3. Evaluate whether a Microsoft Account might be appropriate

### Organizational Policies

**Recommended Policies:**

1. **Default Authentication Method**
   - Prioritize Azure AD federated authentication
   - Limit email OTP to specific scenarios
   - Document when each method is appropriate

2. **Guest User Reviews**
   - Implement regular access reviews
   - Verify identity types match access requirements
   - Remove or remediate accounts with incorrect identity types

3. **External Collaboration Settings**
   - Define which domains can be invited
   - Configure collaboration restrictions appropriately
   - Balance security with collaboration needs

4. **Documentation and Training**
   - Create guest onboarding guides
   - Train administrators on identity type implications
   - Establish helpdesk procedures for guest issues

---

## 📚 Appendix: Technical Details

### Appendix A: User Principal Name (UPN) Formats

Understanding UPN formats helps identify and troubleshoot guest account types.

**ExternalAzureAD Format:**
```
user@externaldomain.com#EXT#@hostingtenant.onmicrosoft.com
```
- Original email domain preserved: `externaldomain.com`
- Uses `@` symbol before `#EXT#`
- Indicates federation with external Azure AD

**Mail/MSA Format:**
```
user_externaldomain.com@guest.hostingtenant.com
```
- Original email domain mangled: `_` replaces `@`
- Uses `@guest.hostingtenant.com` domain suffix
- Indicates non-federated or MSA identity

**Example:**
- **Federated**: `manon.wientjes@sensorfact.nl#EXT#@abbinternaltest.onmicrosoft.com`
- **Non-Federated**: `manon.wientjes_sensorfact.nl@guest.abbinternaltest.com`

### Appendix B: Invitation API Behavior

When using Microsoft Graph API or PowerShell to create invitations, understanding the behavior helps automate proper guest creation.

**Graph API Invitation Endpoint:**
```http
POST https://graph.microsoft.com/v1.0/invitations
```

**Key Properties:**
- `invitedUserEmailAddress`: Target email address
- `inviteRedirectUrl`: Where user goes after redemption
- `sendInvitationMessage`: Whether to send email automatically
- `invitedUserType`: Typically "Guest"

**Automatic Identity Detection:**
Azure AD attempts to determine if the invited email belongs to:
1. An existing Azure AD tenant (will prefer ExternalAzureAD)
2. A Microsoft Account (will use MSA)
3. Neither (will create Mail identity or use OTP)

**Forcing Identity Type:**
You cannot directly force an identity type during invitation creation. The identity type is determined during redemption based on how the user authenticates.

### Appendix C: Conditional Access and Guest Users

Conditional Access policies interact differently with various guest identity types.

**Policy Evaluation:**

1. **ExternalAzureAD Guests**
   - Subject to **both** home tenant and host tenant policies
   - Home tenant MFA is honored
   - Host tenant can add additional requirements
   - Device compliance can be evaluated if device is known to home tenant

2. **Mail Identity Guests**
   - Only subject to host tenant policies
   - Limited MFA options (email OTP only)
   - Cannot evaluate device compliance meaningfully
   - Risk-based policies may have limited effectiveness

3. **Best Practice**
   - Design policies specifically for external users
   - Consider identity type when setting requirements
   - Test policies with different guest types before deployment
   - Document expected behavior for each scenario

**Common Policy Scenarios:**

- **Require MFA**: Works best with ExternalAzureAD (can leverage home tenant MFA)
- **Require Compliant Device**: Only meaningful for ExternalAzureAD guests
- **Require Approved Client App**: Can work with all types but enforcement varies
- **Block Legacy Authentication**: Apply to all guest types for security

---

## 🔗 References

**Official Microsoft Documentation:**

1. [Azure AD B2B Invitation Redemption](https://learn.microsoft.com/en-us/entra/external-id/redemption-experience)  
   Comprehensive guide to the invitation and redemption process

2. [External Identities in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/external-id/external-identities-overview)  
   Overview of external collaboration capabilities

3. [Add Azure AD B2B Collaboration Users](https://learn.microsoft.com/en-us/entra/external-id/add-users-administrator)  
   Administrator guide for inviting guest users

4. [Email One-Time Passcode Authentication](https://learn.microsoft.com/en-us/entra/external-id/one-time-passcode)  
   Details about email OTP authentication method

5. [Properties of an Azure AD B2B User](https://learn.microsoft.com/en-us/entra/external-id/user-properties)  
   Technical details about guest user object properties

6. [Conditional Access for B2B Users](https://learn.microsoft.com/en-us/entra/external-id/authentication-conditional-access)  
   Guide to applying Conditional Access policies to external users

7. [Cross-Tenant Access Settings](https://learn.microsoft.com/en-us/entra/external-id/cross-tenant-access-overview)  
   Configuring trust relationships and access settings between tenants

8. [Troubleshoot Azure AD B2B Collaboration](https://learn.microsoft.com/en-us/entra/external-id/troubleshoot)  
   Common issues and resolutions for B2B scenarios

**Additional Resources:**

9. [Microsoft Graph Invitation API](https://learn.microsoft.com/en-us/graph/api/invitation-post)  
   API reference for programmatic invitation creation

10. [External Identities Best Practices](https://learn.microsoft.com/en-us/entra/architecture/secure-external-access-resources)  
    Security best practices for external collaboration

---

**Document Information:**
- **Created**: November 2, 2025
- **Topic**: Azure AD / Microsoft Entra ID External User Management
- **Related Issue**: [Guest Account Login Fail Issue - 20251014](readme.md)
