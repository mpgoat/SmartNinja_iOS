#import <UIKit/UIKit.h>

#import "MagicalImportFunctions.h"
#import "NSAttributeDescription+MagicalDataImport.h"
#import "NSEntityDescription+MagicalDataImport.h"
#import "NSNumber+MagicalDataImport.h"
#import "NSObject+MagicalDataImport.h"
#import "NSRelationshipDescription+MagicalDataImport.h"
#import "NSString+MagicalDataImport.h"
#import "NSFetchedResultsController+MagicalFetching.h"
#import "NSManagedObject+MagicalAggregation.h"
#import "NSManagedObject+MagicalDataImport.h"
#import "NSManagedObject+MagicalFetching.h"
#import "NSManagedObject+MagicalFinders.h"
#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObject+MagicalRequests.h"
#import "NSManagedObjectContext+MagicalObserving.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalSaves.h"
#import "NSManagedObjectModel+MagicalRecord.h"
#import "NSPersistentStore+MagicalRecord.h"
#import "NSPersistentStore+MagicalRecordPrivate.h"
#import "NSPersistentStoreCoordinator+MagicalAutoMigrations.h"
#import "NSPersistentStoreCoordinator+MagicalInMemoryStoreAdditions.h"
#import "NSPersistentStoreCoordinator+MagicalManualMigrations.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "NSArray+MagicalRecord.h"
#import "NSDictionary+MagicalRecordAdditions.h"
#import "NSError+MagicalRecordErrorHandling.h"
#import "MagicalMigrationManager.h"
#import "MagicalRecord+Actions.h"
#import "MagicalRecord+Options.h"
#import "MagicalRecord+Setup.h"
#import "MagicalRecord+VersionInformation.h"
#import "MagicalRecordDeprecated.h"
#import "MagicalRecordInternal.h"
#import "MagicalRecordLogging.h"
#import "MagicalRecordMOGeneratorProtocol.h"
#import "MagicalRecordShorthand.h"
#import "MagicalRecord.h"
#import "AutoMigratingMagicalRecordStack.h"
#import "AutoMigratingWithSourceAndTargetModelMagicalRecordStack.h"
#import "ClassicSQLiteMagicalRecordStack.h"
#import "ClassicWithBackgroundCoordinatorSQLiteMagicalRecordStack.h"
#import "InMemoryMagicalRecordStack.h"
#import "MagicalRecordStack+Actions.h"
#import "MagicalRecordStack+Private.h"
#import "MagicalRecordStack.h"
#import "ManuallyMigratingMagicalRecordStack.h"
#import "SQLiteMagicalRecordStack.h"
#import "SQLiteWithSavingContextMagicalRecordStack.h"

FOUNDATION_EXPORT double MagicalRecordVersionNumber;
FOUNDATION_EXPORT const unsigned char MagicalRecordVersionString[];
